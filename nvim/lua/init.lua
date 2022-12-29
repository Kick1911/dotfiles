require("number_line")
require("preview_window")

local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

Plug 'Kick1911/nerdtree' -- NERD Tree
Plug 'vim-airline/vim-airline' -- UI
Plug 'vim-airline/vim-airline-themes' -- Themes
Plug('junegunn/fzf', {dir = '~/.fzf', ['do'] = './install --all'})
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug('neoclide/coc.nvim', {branch = 'release'}) -- coc.nvim C syntax
Plug('Shougo/deoplete.nvim', {['do'] = ':UpdateRemotePlugins'})

Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'

vim.call('plug#end')

vim.cmd [[
let g:deoplete#enable_at_startup = 1
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

map("n", "<C-e>", "<C-u>")
map("t", "<Esc>", "<C-\\><C-n>")
map("n", "<Esc>", ":set hlsearch!<CR>")
map("n", "<M-Esc>", ":NERDTreeFind<CR>")
map("n", "<C-f>", ":GFiles<CR>")
map("n", "<C-q>", ":Ag<CR>")

map("n", "tf", ':execute "Git! pull " . FugitiveRemote().remote_name . " " . FugitiveHead()<CR>')
map("n", "tp", ':execute "Git! push origin @:refs/heads/". FugitiveHead()<CR>')
map("n", "th", ':echo "https://github.com/". substitute(g:fugitive#Remote().path, ".git", "", "") ."/blob/". FugitiveHead() ."/". expand("%") ."#L". line(".")<CR>')
map("n", "tr", ":pc<CR>") -- Close preview window
map("n", "tw", ":Buffers<CR>")
map("n", "tt", ":b#<CR>")
map("n", "tq", ":bd<CR>")
map("n", "ts", ":GitGutterStageHunk<CR>")
map("n", "tx", ":GitGutterUndoHunk<CR>")
map("n", "]h", ":GitGutterNextHunk<CR>")
map("n", "[h", ":GitGutterPrevHunk<CR>")
map("n", "te", ":Git! fetch<CR>")
map("n", "tg", ":Git<CR>")
map("n", "td", ":Gdiffsplit!<CR>")
map("n", "tb", ":GBranches<CR>")

-- Visual mode search
map("v", "//", ":y/\\V<C-R>=escape(@\",'/\\')<CR><CR>")

-- Commands
vim.cmd [[silent! exec "source " . argv(0) . "/.vimrc"]]

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
set cpoptions+=u " Fix undo
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
