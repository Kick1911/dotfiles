" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" ---
Plug 'Kick1911/nerdtree'  " NERD Tree
Plug 'Xuyuanp/nerdtree-git-plugin'  " show git status in Nerd tree
Plug 'vim-airline/vim-airline' " UI
" Plug 'ryanoasis/nerd-fonts' " Fonts
" Plug 'ryanoasis/vim-devicons' " Icons
Plug 'ap/vim-buftabline'  " buffers to tabline
Plug 'tomasr/molokai'   " sublime theme
Plug 'dunstontc/vim-vscode-theme'  " vscode theme
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'Shougo/deoplete-clangx'
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

let g:lightline = {
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \             [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'gitbranch#name'
      \ },
      \ }
let g:deoplete#enable_at_startup = 1
let g:nerdtree_tabs_open_on_console_startup = 2
let g:nerdtree_tabs_open_on_new_tab = 1
let g:workspace_autosave_always = 1
let g:airline_powerline_fonts=1
set number
set tabstop=4 shiftwidth=4 expandtab
set backspace=

" Commands
autocmd BufWritePost * NERDTreeFocus | execute 'normal R' | wincmd p

" Shortcuts
tnoremap <Esc> <C-\><C-n>
nnoremap à :belowright split term://zsh<CR>:resize 15<CR>A
nnoremap <Esc> :set hlsearch!<CR>
noremap gr gT

function! MakeSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  if (filewritable(b:sessiondir) != 2)
    exe 'silent !mkdir -p ' b:sessiondir
    redraw!
  endif
  let b:filename = b:sessiondir . '/session.vim'
  exe "mksession! " . b:filename
endfunction

function! LoadSession()
  let b:sessiondir = $HOME . "/.vim/sessions" . getcwd()
  let b:sessionfile = b:sessiondir . "/session.vim"
  if (filereadable(b:sessionfile))
    exe 'source ' b:sessionfile
  else
    echo "No session loaded."
  endif
endfunction

" au VimEnter * nested :call LoadSession()
" au VimLeave * :call MakeSession()

