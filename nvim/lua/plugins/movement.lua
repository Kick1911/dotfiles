local M = {}

local function jump_to_line_percentage(percentage)
  local win = vim.api.nvim_get_current_win()
  local cursor = vim.api.nvim_win_get_cursor(win)
  local current_line_num = cursor[1]

  -- Get the text of the current line
  local line_text = vim.api.nvim_get_current_line()

  -- 1. Find the initial indent (1-indexed in Lua strings)
  local start_idx = line_text:find("%S")

  -- If the line is empty or only whitespace, default to column 0
  if not start_idx then
    -- vim.api.nvim_win_set_cursor(win, { current_line_num, 0 })
    return
  end

  -- 2. Find the trailing text end (strip trailing whitespace safely)
  local end_idx = #line_text:gsub("%s*$", "")

  -- 3. Calculate the length of the actual code block
  local code_length = end_idx - start_idx

  -- 4. Determine the target offset within the code block
  local offset = math.floor(code_length * percentage)

  -- 5. Calculate final column index (0-indexed for Neovim API)
  local target_col = (start_idx - 1) + offset

  -- Set the cursor position
  vim.api.nvim_win_set_cursor(win, { current_line_num, target_col })
end

-- Keymaps
function M.setup(opts)
    vim.keymap.set('n', '<C-h>', function() jump_to_line_percentage(0.00) end, { desc = "Jump to 0% of code line" })
    vim.keymap.set('n', '<C-j>', function() jump_to_line_percentage(0.25) end, { desc = "Jump to 25% of code line" })
    vim.keymap.set('n', '<C-k>', function() jump_to_line_percentage(0.50) end, { desc = "Jump to 50% of code line" })
    vim.keymap.set('n', '<C-l>', function() jump_to_line_percentage(0.75) end, { desc = "Jump to 75% of code line" })
end

return M
