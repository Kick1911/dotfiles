local M = {}

-- ── internal state ────────────────────────────────────────────────────────────

local ns_id = vim.api.nvim_create_namespace("switchback")

local HL_LABEL    = "SwitchbackLabel"
local HL_LABEL_BG = "SwitchbackLabelBG"

-- bookmarks[label] = { buf = <bufnr>, extmark_id = <id> }
local bookmarks = {}
local label_order = {}
local next_index = 1

-- ── helpers ───────────────────────────────────────────────────────────────────

local function index_to_label(n)
  local label = ""
  if n <= 0 then return "" end

  local n_1 = n - 1
  local current_char = string.char(65 + (n_1 % 26))
  local next_n = math.floor(n_1 / 26)

  return index_to_label(next_n) .. current_char
end

--- Return the next fresh label string and advance the counter.
---@return string
local function next_label()
  local lbl = index_to_label(next_index)
  next_index = next_index + 1
  return lbl
end

--- Find a label whose extmark still exists in its buffer.
--- Returns the resolved {row, col} (0-based) or nil if stale.
local function resolve(label)
  local bm = bookmarks[label]

  if not bm then return nil end

  if not vim.api.nvim_buf_is_valid(bm.buf) then return nil end

  local info = vim.api.nvim_buf_get_extmark_by_id(bm.buf, ns_id, bm.extmark_id, {})

  if not info or #info == 0 then return nil end

  return info[1], info[2], bm.buf
end

--- Remove a bookmark entry and its extmark.
local function delete_bookmark(label)
  local bm = bookmarks[label]
  if not bm then return end
  if vim.api.nvim_buf_is_valid(bm.buf) then
    pcall(vim.api.nvim_buf_del_extmark, bm.buf, ns_id, bm.extmark_id)
  end
  bookmarks[label] = nil
  -- Remove from ordered list.
  for i, l in ipairs(label_order) do
    if l == label then
      table.remove(label_order, i)
      break
    end
  end
end

--- Purge bookmarks whose buffers are no longer valid.
local function gc_bookmarks()
  for _, label in ipairs(vim.deepcopy(label_order)) do
    local bm = bookmarks[label]
    if bm and not vim.api.nvim_buf_is_valid(bm.buf) then
      delete_bookmark(label)
    end
  end
end

-- ── core operations ───────────────────────────────────────────────────────────

--- Save the current cursor position as a new bookmark.
local function save_position()
  local buf  = vim.api.nvim_get_current_buf()
  local pos  = vim.api.nvim_win_get_cursor(0)  -- {row, col} 1-based row
  local row  = pos[1] - 1                       -- extmarks use 0-based rows
  local col  = pos[2]

  local label = next_label()

  local extmark_id = vim.api.nvim_buf_set_extmark(buf, ns_id, row, col, {
    -- Virtual text shown to the right of the mark position.
    virt_text = { { " [" .. label .. "]", HL_LABEL } },
    virt_text_pos = "eol",   -- show at end-of-line for clarity
    -- Gravity: mark stays with surrounding text on insert/delete.
    right_gravity = false,
    -- Priority so our marks sit above default diagnostics/git marks.
    priority = 200,
    -- Optionally draw a subtle sign in the gutter.
    sign_text   = label:sub(1, 2),
    sign_hl_group = HL_LABEL_BG,
  })

  bookmarks[label] = { buf = buf, extmark_id = extmark_id }
  table.insert(label_order, label)

  vim.notify(
    string.format("Switchback: saved position as [%s]", label),
    vim.log.levels.INFO
  )
end

--- Jump to the bookmark with the given label (exact, uppercase).
local function jump_to(label)
  label = label:upper()
  local row, col, buf = resolve(label)
  if not row then
    vim.notify(
      string.format("Switchback: label [%s] not found or stale.", label),
      vim.log.levels.WARN
    )
    return
  end

  -- Switch to the buffer (may be in a different window).
  local target_win = nil
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    if vim.api.nvim_win_get_buf(win) == buf then
      target_win = win
      break
    end
  end

  if target_win then
    vim.api.nvim_set_current_win(target_win)
  else
    -- Buffer not visible; open it in the current window.
    vim.api.nvim_set_current_buf(buf)
  end

  vim.api.nvim_win_set_cursor(0, { row + 1, col })
end

--- Delete the bookmark whose extmark is closest to the current cursor line,
--- or ask for a label interactively.
local function delete_at_cursor()
  local buf = vim.api.nvim_get_current_buf()
  local row = vim.api.nvim_win_get_cursor(0)[1] - 1

  -- Find bookmarks on the current buffer and prefer the current line.
  local best_label, best_dist
  for _, label in ipairs(label_order) do
    local bm = bookmarks[label]
    if bm and bm.buf == buf then
      local info = vim.api.nvim_buf_get_extmark_by_id(buf, ns_id, bm.extmark_id, {})
      if info and #info > 0 then
        local dist = math.abs(info[1] - row)
        if not best_dist or dist < best_dist then
          best_dist  = dist
          best_label = label
        end
      end
    end
  end

  if best_label then
    delete_bookmark(best_label)
    vim.notify(
      string.format("Switchback: deleted bookmark [%s].", best_label),
      vim.log.levels.INFO
    )
  else
    vim.notify("Switchback: no bookmark found in this buffer.", vim.log.levels.WARN)
  end
end

-- ── interactive label-capture ─────────────────────────────────────────────────

--- Read characters from the user until the input matches a known label
--- or they press <Esc>/<CR> to abort.
--- Displays a live echo in the command line.
local function prompt_and_jump()
  gc_bookmarks()

  if vim.tbl_isempty(bookmarks) then
    vim.notify("Switchback: no bookmarks saved.", vim.log.levels.WARN)
    return
  end

  -- Build a set of known labels (uppercase) for fast lookup.
  local known = {}
  for label in pairs(bookmarks) do
    known[label] = true
  end

  -- Find the maximum label length so we know when to auto-confirm.
  local max_len = 0
  for label in pairs(bookmarks) do
    if #label > max_len then max_len = #label end
  end

  local input = ""
  vim.api.nvim_echo({ { "Switchback » ", "Title" } }, false, {})

  while true do
    local ok, char = pcall(vim.fn.getcharstr)
    if not ok then break end

    -- <Esc> or <C-c> → abort.
    if char == "\27" or char == "\3" then
      vim.api.nvim_echo({ { "Switchback: aborted.", "Comment" } }, false, {})
      break
    end

    -- <CR> or <NL> → attempt jump with current input.
    if char == "\r" or char == "\n" then
      jump_to(input)
      break
    end

    -- <BS> → remove last character.
    if char == "\8" or char == "\127" then
      if #input > 0 then
        input = input:sub(1, -2)
      end
    elseif char:match("[A-Za-z]") then
      input = input .. char:upper()
    else
      -- Ignore non-alphabetic chars.
    end

    -- Echo current input.
    vim.api.nvim_echo(
      { { "Switchback » " .. input, "Title" } },
      false, {}
    )

    -- Auto-jump if the exact input matches a known label.
    if known[input] then
      -- If no longer label starts with this prefix, jump immediately.
      local prefix_only = false
      for label in pairs(known) do
        if label ~= input and label:sub(1, #input) == input then
          prefix_only = true
          break
        end
      end
      if not prefix_only then
        jump_to(input)
        break
      end
    end

    -- If input length exceeds maximum possible label, abort.
    if #input > max_len then
      vim.api.nvim_echo(
        { { "Switchback: unknown label [" .. input .. "].", "WarningMsg" } },
        false, {}
      )
      break
    end
  end

  -- Clear the command line after a short delay.
  vim.defer_fn(function()
    vim.api.nvim_echo({ { "", "Normal" } }, false, {})
  end, 1500)
end

-- ── floating list window ──────────────────────────────────────────────────────

--- Open a floating window listing all active bookmarks.
local function list_bookmarks()
  gc_bookmarks()

  if vim.tbl_isempty(bookmarks) then
    vim.notify("Switchback: no bookmarks saved.", vim.log.levels.INFO)
    return
  end

  -- Build lines.
  local lines = { "  Switchback Bookmarks  ", string.rep("─", 40) }
  for _, label in ipairs(label_order) do
    local bm = bookmarks[label]
    if bm then
      local row, col, buf = resolve(label)
      if row then
        local bufname = vim.api.nvim_buf_get_name(buf)
        bufname = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
        table.insert(
          lines,
          string.format("  [%-4s]  %s  line %-5d  col %d", label, bufname, row + 1, col + 1)
        )
      end
    end
  end

  if #lines == 2 then
    -- All bookmarks were stale.
    vim.notify("Switchback: all bookmarks are stale.", vim.log.levels.WARN)
    return
  end

  table.insert(lines, "")
  table.insert(lines, "  Press any key to close")

  local width  = 0
  for _, l in ipairs(lines) do
    if #l > width then width = #l end
  end
  width = math.max(width + 2, 44)
  local height = #lines

  local ui    = vim.api.nvim_list_uis()[1]
  local row_f = math.floor((ui.height - height) / 2)
  local col_f = math.floor((ui.width  - width)  / 2)

  local buf_f = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf_f, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf_f, "modifiable", false)
  vim.api.nvim_buf_set_option(buf_f, "buftype", "nofile")

  -- Highlight header.
  vim.api.nvim_buf_add_highlight(buf_f, -1, "Title",   0, 0, -1)
  vim.api.nvim_buf_add_highlight(buf_f, -1, "Comment", 1, 0, -1)

  local win_f = vim.api.nvim_open_win(buf_f, true, {
    relative = "editor",
    row      = row_f,
    col      = col_f,
    width    = width,
    height   = height,
    style    = "minimal",
    border   = "rounded",
    title    = " Switchback ",
    title_pos = "center",
  })

  vim.api.nvim_win_set_option(win_f, "winhl",
    "Normal:NormalFloat,FloatBorder:FloatBorder")
  vim.api.nvim_win_set_option(win_f, "cursorline", true)

  -- Close on any keypress.
  local close = function()
    if vim.api.nvim_win_is_valid(win_f) then
      vim.api.nvim_win_close(win_f, true)
    end
  end
  for _, key in ipairs({ "q", "<Esc>", "<CR>", "<Space>" }) do
    vim.keymap.set("n", key, close, { buffer = buf_f, nowait = true, silent = true })
  end
end

-- ── setup ─────────────────────────────────────────────────────────────────────

---@class SwitchbackConfig
---@field keymaps? { save?: string, delete?: string, list?: string, jump?: string }

---@param opts? SwitchbackConfig
function M.setup(opts)
  opts = opts or {}
  local km = vim.tbl_deep_extend("force", {
    save   = "ms",
    delete = "md",
    list   = "ml",
    jump   = "go",
  }, opts.keymaps or {})

  -- Define highlight groups (link to built-ins so colorschemes can override).
  vim.api.nvim_set_hl(0, HL_LABEL,    { link = "DiagnosticHint",    default = true })
  vim.api.nvim_set_hl(0, HL_LABEL_BG, { link = "DiagnosticSignHint", default = true })

  vim.keymap.set("n", km.save,   save_position,  { desc = "Switchback: save position",    silent = true })
  vim.keymap.set("n", km.delete, delete_at_cursor,{ desc = "Switchback: delete bookmark",  silent = true })
  vim.keymap.set("n", km.list,   list_bookmarks,  { desc = "Switchback: list bookmarks",   silent = true })
  vim.keymap.set("n", km.jump,   prompt_and_jump, { desc = "Switchback: jump to bookmark", silent = true })

  -- Clean up stale bookmarks whenever a buffer is deleted.
  vim.api.nvim_create_autocmd("BufDelete", {
    callback = function() vim.schedule(gc_bookmarks) end,
    desc = "Switchback: garbage-collect stale bookmarks",
  })
end

return M
