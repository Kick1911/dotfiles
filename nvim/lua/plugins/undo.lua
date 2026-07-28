local M = {}

-- Track the toggle state
local last_state = {
  changedtick = -1,
  seq_before_undo = nil,
  is_undone = false,
}

--- Legacy Vi-style toggle undo implementation
function M.toggle_undo()
  local current_tick = vim.api.nvim_buf_get_changedtick(0)
  local tree = vim.fn.undotree()

  -- If the buffer was edited since the last toggle, reset state
  if current_tick ~= last_state.changedtick then
    last_state.is_undone = false
    last_state.seq_before_undo = tree.seq_cur
  end

  if not last_state.is_undone then
    -- State A -> State B: Perform standard undo
    last_state.seq_before_undo = tree.seq_cur
    vim.cmd("silent! undo")
    last_state.is_undone = true
  else
    -- State B -> State A: Undo the undo (return to previous sequence point)
    if last_state.seq_before_undo then
      vim.cmd("silent! undo " .. last_state.seq_before_undo)
    end
    last_state.is_undone = false
  end

  -- Update changedtick to the new buffer state after undo/redo
  last_state.changedtick = vim.api.nvim_buf_get_changedtick(0)
end

-- Keymap binding for Normal mode
vim.keymap.set("n", "u", M.toggle_undo, {
  noremap = true,
  silent = true,
  desc = "Vi-style toggle undo"
})

return M
