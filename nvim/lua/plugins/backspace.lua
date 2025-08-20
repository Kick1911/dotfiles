local M = {}

local insert_start_col = nil

local function disable_while_insert_mode(key)
  vim.keymap.set("i", key, function()
    return ""
  end)
end

local function disable_non_buffer_insert_backspace(key)
  vim.keymap.set("i", key, function()
    local _, col = unpack(vim.api.nvim_win_get_cursor(0))
    if insert_start_col and col <= insert_start_col then
      return ""
    end
    return key
  end, { expr = true, noremap = true, silent = true })
end

function M.setup()
  vim.api.nvim_create_autocmd("InsertEnter", {
    callback = function()
      local _, col = unpack(vim.api.nvim_win_get_cursor(0))
      insert_start_col = col
    end
  })

  disable_while_insert_mode("<Del>")
  disable_non_buffer_insert_backspace("<BS>")
  disable_non_buffer_insert_backspace("<C-w>")
end

return M
