local M = {}

function M.setup()
  -- Bootstrap lazy.nvim
  local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
  if not (vim.uv or vim.loop).fs_stat(lazypath) then
    local lazyrepo = "https://github.com/folke/lazy.nvim.git"
    local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
    if vim.v.shell_error ~= 0 then
      vim.api.nvim_echo({
        { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
        { out, "WarningMsg" },
        { "\nPress any key to exit..." },
      }, true, {})
      vim.fn.getchar()
      os.exit(1)
    end
  end
  vim.opt.rtp:prepend(lazypath)

  -- Make sure to setup `mapleader` and `maplocalleader` before
  -- loading lazy.nvim so that mappings are correct.
  -- This is also a good place to setup other settings (vim.opt)
  vim.g.mapleader = " "
  vim.g.maplocalleader = "\\"

  -- Setup lazy.nvim
  require("lazy").setup({
    spec = {
      -- Plugin installs moved from init.lua:
      "Kick1911/nerdtree", -- NERD Tree
      "vim-airline/vim-airline", -- UI
      "vim-airline/vim-airline-themes", -- Themes
      { "junegunn/fzf", dir = "~/.fzf", build = "./install --all" },
      "junegunn/fzf.vim",
      "stsewd/fzf-checkout.vim",
      -- "chrisgrieser/nvim-spider",
      { "nvim-treesitter/nvim-treesitter", branch = "main", build = ":TSUpdate" },
      "mhartington/oceanic-next", -- Treesitter highlighting
      "sakhnik/nvim-gdb",
      "tpope/vim-fugitive",
      "airblade/vim-gitgutter",
      "neovim/nvim-lspconfig",
      "mason-org/mason.nvim",
      "seblj/roslyn.nvim",
      "ray-x/lsp_signature.nvim",
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = true },
  })
end

return M
