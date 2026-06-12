local M = {}

local ns_id = vim.api.nvim_create_namespace("switchback")

local HL_LABEL    = "SwitchbackLabel"
local HL_LABEL_BG = "SwitchbackLabelBG"

local pool_labels = { "q", "w", "e", "r", "t" }
local pool_size = #pool_labels

local bookmarks = {}
local label_order = {}
local next_pool_index = 1

-- ── helpers ───────────────────────────────────────────────────────────────────

local function resolve(label)
  local bm = bookmarks[label]
  if not bm then return nil end
  if not vim.api.nvim_buf_is_valid(bm.buf) then return nil end
  local info = vim.api.nvim_buf_get_extmark_by_id(bm.buf, ns_id, bm.extmark_id, {})
  if not info or #info == 0 then return nil end
  return info[1], info[2], bm.buf
end

local function delete_bookmark(label)
  local bm = bookmarks[label]
  if not bm then return end
  if vim.api.nvim_buf_is_valid(bm.buf) then
    pcall(vim.api.nvim_buf_del_extmark, bm.buf, ns_id, bm.extmark_id)
  end
  bookmarks[label] = nil
  for i, l in ipairs(label_order) do
    if l == label then
      table.remove(label_order, i)
      break
    end
  end
end

local function label_for_buf(buf)
  for label, bm in pairs(bookmarks) do
    if bm and bm.buf == buf then
      return label
    end
  end
  return nil
end

local function gc_bookmarks()
  for _, label in ipairs(vim.deepcopy(label_order)) do
    local bm = bookmarks[label]
    if bm and not vim.api.nvim_buf_is_valid(bm.buf) then
      delete_bookmark(label)
    end
  end
end

-- ── auto-save on text change ──────────────────────────────────────────────────

local function auto_save_position()
  local buf = vim.api.nvim_get_current_buf()
  local bt = vim.api.nvim_buf_get_option(buf, "buftype")
  if bt ~= "" then return end

  local pos = vim.api.nvim_win_get_cursor(0)
  local row = pos[1] - 1
  local col = pos[2]

  local label = label_for_buf(buf)
  if label then
    delete_bookmark(label)
  else
    label = pool_labels[next_pool_index]
    next_pool_index = (next_pool_index % pool_size) + 1
    if bookmarks[label] then
      delete_bookmark(label)
    end
  end

  local extmark_id = vim.api.nvim_buf_set_extmark(buf, ns_id, row, col, {
    virt_text = { { " [" .. label .. "]", HL_LABEL } },
    virt_text_pos = "eol",
    right_gravity = false,
    priority = 200,
    sign_text   = label,
    sign_hl_group = HL_LABEL_BG,
  })

  bookmarks[label] = { buf = buf, extmark_id = extmark_id }
  table.insert(label_order, label)
end

-- ── JUMP mode ─────────────────────────────────────────────────────────────────

local function jump_to(label)
  local row, col, buf = resolve(label)
  if not row then return false end

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
    vim.api.nvim_set_current_buf(buf)
  end

  vim.api.nvim_win_set_cursor(0, { row + 1, col })
  return true
end

local function jump_mode()
  gc_bookmarks()

  if vim.tbl_isempty(bookmarks) then
    vim.notify("Switchback: no bookmarks saved.", vim.log.levels.WARN)
    return
  end

  while true do
    local echo_parts = { { "JUMP  ", "Title" } }
    for _, l in ipairs(pool_labels) do
      local active = resolve(l) ~= nil
      local hl = active and HL_LABEL or "Comment"
      table.insert(echo_parts, { l .. "  ", hl })
    end
    table.insert(echo_parts, { "ESC to exit", "Comment" })
    vim.api.nvim_echo(echo_parts, false, {})

    local ok, char = pcall(vim.fn.getcharstr)
    if not ok then break end

    if char == "\27" or char == "\3" then
      break
    end

    if resolve(char) then
      jump_to(char)
      vim.api.nvim_echo({ { "", "Normal" } }, false, {})
      vim.cmd("normal! zz")
      vim.defer_fn(jump_mode, 50)
      return
    end
  end

  vim.defer_fn(function()
    vim.api.nvim_echo({ { "", "Normal" } }, false, {})
  end, 100)
end

-- ── floating list window ──────────────────────────────────────────────────────

local function list_bookmarks()
  gc_bookmarks()

  if vim.tbl_isempty(bookmarks) then
    vim.notify("Switchback: no bookmarks saved.", vim.log.levels.INFO)
    return
  end

  local lines = { "  Switchback Bookmarks  ", string.rep("─", 40) }
  for _, label in ipairs(label_order) do
    local bm = bookmarks[label]
    if bm then
      local row, col, buf = resolve(label)
      if row then
        local bufname = vim.api.nvim_buf_get_name(buf)
        bufname = bufname ~= "" and vim.fn.fnamemodify(bufname, ":t") or "[No Name]"
        table.insert(lines, string.format("  [%-4s]  %s  line %-5d  col %d", label, bufname, row + 1, col + 1))
      end
    end
  end

  if #lines == 2 then
    vim.notify("Switchback: all bookmarks are stale.", vim.log.levels.WARN)
    return
  end

  table.insert(lines, "")
  table.insert(lines, "  Press any key to close")

  local width = 0
  for _, l in ipairs(lines) do
    if #l > width then width = #l end
  end
  width = math.max(width + 2, 44)
  local height = #lines

  local ui = vim.api.nvim_list_uis()[1]
  local row_f = math.floor((ui.height - height) / 2)
  local col_f = math.floor((ui.width - width) / 2)

  local buf_f = vim.api.nvim_create_buf(false, true)
  vim.api.nvim_buf_set_lines(buf_f, 0, -1, false, lines)
  vim.api.nvim_buf_set_option(buf_f, "modifiable", false)
  vim.api.nvim_buf_set_option(buf_f, "buftype", "nofile")

  vim.api.nvim_buf_add_highlight(buf_f, -1, "Title", 0, 0, -1)
  vim.api.nvim_buf_add_highlight(buf_f, -1, "Comment", 1, 0, -1)

  local win_f = vim.api.nvim_open_win(buf_f, true, {
    relative = "editor",
    row = row_f,
    col = col_f,
    width = width,
    height = height,
    style = "minimal",
    border = "rounded",
    title = " Switchback ",
    title_pos = "center",
  })

  vim.api.nvim_win_set_option(win_f, "winhl", "Normal:NormalFloat,FloatBorder:FloatBorder")
  vim.api.nvim_win_set_option(win_f, "cursorline", true)

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

function M.setup(opts)
  opts = opts or {}
  local km = vim.tbl_deep_extend("force", {
    list = "ml",
    jump = "go",
  }, opts.keymaps or {})

  vim.api.nvim_set_hl(0, HL_LABEL, { link = "DiagnosticHint", default = true })
  vim.api.nvim_set_hl(0, HL_LABEL_BG, { link = "DiagnosticSignHint", default = true })

  vim.keymap.set("n", km.list, list_bookmarks, { desc = "Switchback: list bookmarks", silent = true })
  vim.keymap.set("n", km.jump, jump_mode, { desc = "Switchback: jump to bookmark", silent = true })

  vim.api.nvim_create_autocmd({ "TextChanged", "TextChangedI" }, {
    callback = function() vim.schedule(auto_save_position) end,
    desc = "Switchback: auto-save position on edit",
  })

  vim.api.nvim_create_autocmd("BufDelete", {
    callback = function() vim.schedule(gc_bookmarks) end,
    desc = "Switchback: garbage-collect stale bookmarks",
  })
end

return M
