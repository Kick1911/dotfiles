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
      {
        "lukas-reineke/indent-blankline.nvim",
        main = "ibl",
        ---@module "ibl"
        ---@type ibl.config
        opts = {
          indent = {
            char = "│", -- Can swap for ┊ or ┆
            tab_char = "│",
          },
          scope = { -- Change scope colour vim.api.nvim_set_hl(0, "IblScope", { fg = "#ff8800" })
            enabled = true,
            show_start = false,
            show_end = false,
          },
        },
      },
      {
        "neovim/nvim-lspconfig",
        config = function()
          vim.lsp.enable("pyrefly")
          vim.lsp.enable("clangd")

          require('roslyn').setup({
            args = {
              '--logLevel=Information',
            },
            config = {
              -- Pass your standard on_attach and capabilities here if you use them
              on_attach = function(client, bufnr)
                -- Your custom keymaps (e.g., gd for definition, K for hover)
              end,
            },
          })

        end,
      },
      "mason-org/mason.nvim",
      "seblj/roslyn.nvim",
      "ray-x/lsp_signature.nvim",
    },
    -- Configure any other settings here. See the documentation for more details.
    -- colorscheme that will be used when installing plugins.
    install = { colorscheme = { "habamax" } },
    -- automatically check for plugin updates
    checker = { enabled = false },
  })
end

return M
