" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" ---
Plug 'scrooloose/nerdtree'  " NERD Tree
Plug 'Xuyuanp/nerdtree-git-plugin'  " show git status in Nerd tree
Plug 'itchyny/lightline.vim'  " UI
Plug 'ap/vim-buftabline'  " buffers to tabline
Plug 'tomasr/molokai'   " sublime theme
Plug 'dunstontc/vim-vscode-theme'  " vscode theme
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'jiangmiao/auto-pairs'
Plug 'sheerun/vim-polyglot'

Plug 'janko-m/vim-test'  " Tests

" Code {{{
Plug 'scrooloose/nerdcommenter'  " NERD commenter. Quickly comment lines
Plug 'editorconfig/editorconfig-vim'
Plug 'herringtondarkholme/yats.vim'  " Typescript syntax
Plug 'posva/vim-vue'   " Vue JS syntax highlighting
"Plug 'mxw/vim-jsx'
Plug 'maxmellon/vim-jsx-pretty'
" Plug 'mattn/emmet-vim' " already in coc
Plug 'prettier/vim-prettier'
Plug 'othree/xml.vim'
Plug 'othree/html5.vim'
Plug 'cakebaker/scss-syntax.vim'
Plug 'tpope/vim-surround'

Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }} " Markdown preview
" }}}

" GIT {{{
Plug 'tpope/vim-fugitive'
Plug 'airblade/vim-gitgutter'
" }}}

" Initialize plugin system
call plug#end()


let g:deoplete#enable_at_startup = 1
let g:nerdtree_tabs_open_on_console_startup = 2
let g:nerdtree_tabs_open_on_new_tab = 1
set nohlsearch
set number
set tabstop=4
set shiftwidth=4

" Commands
autocmd BufWritePost * NERDTreeFocus | execute 'normal R' | wincmd p

" Shortcuts
tnoremap <Esc> <C-\><C-n>
nnoremap à :belowright split term://zsh<CR>:resize 10<CR>A
noremap gr gT

