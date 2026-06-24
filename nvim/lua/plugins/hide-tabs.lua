local augroup = vim.api.nvim_create_augroup("AutoListToggle", { clear = true })
local timer = nil

vim.wo.list = true
vim.api.nvim_create_autocmd({ "CursorMoved", "WinEnter", "BufWinEnter" }, {
  group = augroup,
  callback = function()
    vim.wo.listchars = "tab:>-,trail:~,extends:>,precedes:<"

    if timer then
      timer:stop()
      timer:close()
    end

    timer = vim.defer_fn(function()
      local mode = vim.fn.mode()
      if mode == "n" or mode == "i" then
        vim.wo.listchars = "tab:\\ ,trail:~,extends:>,precedes:<"
      end
      timer = nil
    end, 1000)
  end,
})
