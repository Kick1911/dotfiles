-- TODO:
-- Reset positions for cursor on redo/undo
local M = {}

local toggle_state = {
  last_seq = nil,
  toggled = false,
}

local function reset_toggle()
  toggle_state.last_seq = nil
  toggle_state.toggled = false
end

function M.toggle_undo()
  local cur_seq = vim.fn.undotree().seq_cur

  if toggle_state.toggled then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-r>", true, false, true), "n", false)
    toggle_state.toggled = false
  else
    -- No toggle state yet, perform regular undo
    vim.cmd("normal! u")
    toggle_state.last_seq = vim.fn.undotree().seq_cur
    toggle_state.toggled = true
  end
end

function M.redo()
  if toggle_state.toggled then
    vim.cmd("normal! u")
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-r>", true, false, true), "n", false)
  end
end

function M.setup()
  vim.keymap.set("n", "u", M.toggle_undo, { noremap = true, silent = true })
  vim.keymap.set("n", "<C-r>", M.redo, { noremap = true, silent = true })

  vim.api.nvim_create_autocmd({ "InsertEnter", "InsertLeave", "TextChangedI", "TextChangedP", "CmdlineLeave" }, {
    callback = reset_toggle,
  })
end

return M
