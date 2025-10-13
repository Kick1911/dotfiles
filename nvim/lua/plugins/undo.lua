local M = {}

local toggle_state = {
  toggled = false,
}

local function reset_toggle()
  toggle_state.toggled = false
end

local function move_cursor_down()
  local win = vim.api.nvim_get_current_win()
  local row, col = unpack(vim.api.nvim_win_get_cursor(win))

  if not vim.api.nvim_win_is_valid(win) then
    return 2
  end

  local total_lines = vim.api.nvim_buf_line_count(0)
  local new_row = math.min(row + 1, total_lines)

  pcall(vim.api.nvim_win_set_cursor, win, {new_row, col})
end

function M.toggle_undo()
  if toggle_state.toggled then
    vim.cmd("redo")
    toggle_state.toggled = false
  else
    vim.cmd("normal! u")
    toggle_state.toggled = true
  end
end

function M.redo()
  local seq_cur = vim.fn.undotree().seq_cur
  local seq_last = vim.fn.undotree().seq_last

  if seq_cur == seq_last or seq_cur < 1 then
    return
  end

  if toggle_state.toggled then
    vim.cmd("normal! u")
  else
    vim.cmd("redo")
  end
end

function M.setup()
  vim.keymap.set("n", "u", M.toggle_undo, { noremap = true, silent = true })
  vim.keymap.set("n", "<C-r>", M.redo, { noremap = true, silent = true })

  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "TextChangedI", "TextChangedP" }, {
    callback = reset_toggle,
  })
end

return M
