local augroup = vim.api.nvim_create_augroup("AutoListToggle", { clear = true })
local timer = nil

vim.api.nvim_create_autocmd({ "CursorMoved", "WinEnter", "BufWinEnter" }, {
  group = augroup,
  callback = function()
    vim.wo.list = true

    if timer then
      timer:stop()
      timer:close()
    end

    timer = vim.defer_fn(function()
      local mode = vim.fn.mode()
      if mode == "n" or mode == "i" then
        vim.wo.list = false
      end
      timer = nil
    end, 1000)
  end,
})
