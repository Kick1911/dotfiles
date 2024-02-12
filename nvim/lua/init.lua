require "plugins"
require "experimental"

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'Kick1911/nerdtree' -- NERD Tree
Plug 'vim-airline/vim-airline' -- UI
Plug 'vim-airline/vim-airline-themes' -- Themes
Plug('junegunn/fzf', {dir = '~/.fzf', ['do'] = './install --all'})
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
-- Plug 'chrisgrieser/nvim-spider'
Plug 'sheerun/vim-polyglot'

Plug 'williamboman/mason.nvim'
Plug 'williamboman/mason-lspconfig.nvim'
Plug 'neovim/nvim-lspconfig'
Plug 'ray-x/lsp_signature.nvim'
-- Plug('nvim-telescope/telescope.nvim', {branch = '0.1.1'})
Plug('nvim-treesitter/nvim-treesitter', {['do'] = ':TSUpdate'})

-- GIT plugins
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

vim.call('plug#end')

require("mason").setup()
require("mason-lspconfig").setup()

require("lsp")
require'lspconfig'.clangd.setup{}
-- require'lspconfig'.pyright.setup{}

-- Default : "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
vim.cmd [[
let g:deoplete#enable_at_startup = 1
set guicursor=v-c-sm:block,n-i-ci-ve:ver25,r-cr-o:hor20,a:blinkon100
]]
vim.g.airline_theme = 'base16'
vim.g.airline_powerline_fonts=1
vim.g.airline_left_sep = ''
vim.g.airline_left_alt_sep = ''
vim.g.airline_right_sep = ''
vim.g.airline_right_alt_sep = ''
vim.g.workspace_autosave_always = 1
vim.g.gitgutter_highlight_linenrs = 0
vim.g.fzf_checkout_git_options = '--sort=-committerdate'

vim.g.haskell_classic_highlighting = 1
vim.g.haskell_enable_quantification = 1   -- to enable highlighting of `forall`
vim.g.haskell_enable_recursivedo = 1      -- to enable highlighting of `mdo` and `rec`
vim.g.haskell_enable_arrowsyntax = 1      -- to enable highlighting of `proc`
vim.g.haskell_enable_pattern_synonyms = 1 -- to enable highlighting of `pattern`
vim.g.haskell_enable_typeroles = 1        -- to enable highlighting of type roles
vim.g.haskell_enable_static_pointers = 1  -- to enable highlighting of `static`
vim.g.haskell_backpack = 1                -- to enable highlighting of backpack keywords
--[[
vim.g.lightline = {
  active = {
    left = { { 'mode', 'paste' },
             { 'gitbranch', 'readonly', 'filename', 'modified' } }
  },
  component_function = {
    gitbranch = 'gitbranch#name'
  },
}
]]--

function map(mode, lhs, rhs)
    vim.api.nvim_set_keymap(mode, lhs, rhs, { noremap = true, silent = true })
end

-- Shortcuts
-- vim.keymap.set({"n"}, "w", "<cmd>lua require('spider').motion('w')<CR>", { desc = "Spider-w" })
-- vim.keymap.set({"n"}, "e", "<cmd>lua require('spider').motion('e')<CR>", { desc = "Spider-e" })
-- vim.keymap.set({"n"}, "b", "<cmd>lua require('spider').motion('b')<CR>", { desc = "Spider-b" })
-- vim.keymap.set({"n"}, "ge", "<cmd>lua require('spider').motion('ge')<CR>", { desc = "Spider-ge" })

-- Disable movement in insert mode
map("i", "<up>", "<NOP>")
map("i", "<down>", "<NOP>")
map("i", "<left>", "<NOP>")
map("i", "<right>", "<NOP>")

map("n", "<up>", "<NOP>")
map("n", "<down>", "<NOP>")
map("n", "<left>", "<NOP>")
map("n", "<right>", "<NOP>")

map("v", "<up>", "<NOP>")
map("v", "<down>", "<NOP>")
map("v", "<left>", "<NOP>")
map("v", "<right>", "<NOP>")

map("n", "<A-j>", "<cmd>m .+1<CR>==")
map("n", "<A-k>", "<cmd>m .-2<CR>==")
map("v", "<A-j>", "<cmd>m '>+1<CR>gv=gv")
map("v", "<A-k>", "<cmd>m '<-2<CR>gv=gv")
map("i", "<A-j>", "<Esc><cmd>m .+1<CR>==gi")
map("i", "<A-k>", "<Esc><cmd>m .-2<CR>==gi")

map("n", "<C-d>", "<C-d>zz")
map("n", "<C-u>", "<C-u>zz")
map("n", "<C-e>", "<C-u>zz")
map("t", "<Esc>", "<C-\\><C-n>")
map("n", "<Esc>", "<cmd>set hlsearch!<CR>")
map("n", "<M-Esc>", "<cmd>NERDTreeFind<CR>")
map("n", "<C-f>", "<cmd>GFiles<CR>")
map("n", "<C-q>", "<cmd>Ag<CR>")

map("n", "tf", '<cmd>execute "Git! pull " . FugitiveRemote().remote_name . " " . FugitiveHead()<CR>')
map("n", "tp", '<cmd>execute "Git! push origin @:refs/heads/". FugitiveHead()<CR>')
map("n", "th", '<cmd>echo "https://github.com/". substitute(g:fugitive#Remote().path, ".git", "", "") ."/blob/". FugitiveHead() ."/". expand("%") ."#L". line(".")<CR>')
map("n", "tr", "<cmd>pc<CR>") -- Close preview window
map("n", "tw", "<cmd>Buffers<CR>")
map("n", "tt", "<cmd>b#<CR>")
map("n", "tq", "<cmd>bd<CR>")
map("n", "ts", "<cmd>GitGutterStageHunk<CR>")
map("n", "tx", "<cmd>GitGutterUndoHunk<CR>")
map("n", "]h", "<cmd>GitGutterNextHunk<CR>")
map("n", "[h", "<cmd>GitGutterPrevHunk<CR>")
map("n", "te", "<cmd>Git! fetch<CR>")
map("n", "tg", "<cmd>Git | NERDTreeClose<CR>")
map("n", "td", "<cmd>Gdiffsplit!<CR>")
map("n", "tb", "<cmd>GBranches<CR>")

-- Visual mode search
vim.cmd [[
vmap // y/\V<C-R>=escape(@",'/\')<CR><CR>
]]

-- Default colour of line number
vim.cmd [[
hi LineNr ctermfg=blue
hi Search cterm=NONE ctermfg=red ctermbg=lightgreen
hi CocFloating ctermfg=red ctermbg=black
hi ColorColumn ctermbg=131
hi clear Pmenu
hi clear TabLineFill
hi clear SignColumn
hi clear GitGutterAdd
hi clear GitGutterChange
hi clear GitGutterDelete
]]

-- Vim config
vim.cmd [[
set cpoptions+=$ " Fix editing not really
set cpoptions+=v " Fix backspacing
set hidden " Can change buffers without writing file
set number
set tabstop=4 shiftwidth=4 expandtab
set backspace=
set nosmartindent
set nocindent
packadd termdebug
set listchars=tab:>-,trail:~,extends:>,precedes:<
set list
set colorcolumn=79
setlocal foldmethod=indent
set mouse=
]]

-- Commands
vim.cmd [[silent! exec "source " . argv(0) . "/.vimrc"]]
