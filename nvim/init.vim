lua require('number_line')
" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" ---
Plug 'Kick1911/nerdtree'  " NERD Tree
" Plug 'Xuyuanp/nerdtree-git-plugin'  " show git status in Nerd tree
Plug 'vim-airline/vim-airline' " UI
Plug 'vim-airline/vim-airline-themes' " Themes
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'} " Fast Python linter
" Plug 'neoclide/coc.nvim', {'branch': 'release'} " coc.nvim C syntax
" Plug 'deoplete-plugins/deoplete-clang'
" Plug 'dense-analysis/ale'
Plug 'chrisgrieser/nvim-spider' " Awesome word traversal plugin
Plug 'sheerun/vim-polyglot'
" Plug 'rking/ag.vim' " Text search
" Plug 'Chun-Yang/vim-action-ag' " Ag compliment
" Plug 'rafi/awesome-vim-colorschemes'

" Code {{{
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
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
let g:airline_theme = 'base16'
let g:airline_powerline_fonts=1
let g:airline_left_sep = ''
let g:airline_left_alt_sep = ''
let g:airline_right_sep = ''
let g:airline_right_alt_sep = ''
let g:workspace_autosave_always = 1
let g:gitgutter_highlight_linenrs = 0
let g:fzf_checkout_git_options = '--sort=-committerdate'
let $NVIM_TUI_ENABLE_CURSOR_SHAPE=1

" Vim config
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
set tw=79
setlocal foldmethod=indent
set mouse=
" Default : "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20"
set guicursor=v-c-sm:block,n-i-ci-ve:ver25,r-cr-o:hor20,a:blinkon100

" https://github.com/rafi/awesome-vim-colorschemes
" colorscheme dogrun

" Default colour of line number
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
" Enable true color 启用终端24位色
" if exists('+termguicolors')
"  set termguicolors
" endif

" Shortcuts
"  commands:                            modes:
"                                       Normal  Visual+Select  Operator-pending
"  :map   :noremap   :unmap   :mapclear  yes    yes             yes
"  :nmap  :nnoremap  :nunmap  :nmapclear yes    -               -
"  :vmap  :vnoremap  :vunmap  :vmapclear -      yes             -
"  :omap  :onoremap  :ounmap  :omapclear -      -               yes

nmap w <cmd>lua require('spider').motion('w')<CR>
nmap e <cmd>lua require('spider').motion('e')<CR>
nmap b <cmd>lua require('spider').motion('b')<CR>
nmap ge <cmd>lua require('spider').motion('ge')<CR>

tnoremap <Esc> <C-\><C-n>
nnoremap <C-e> <C-u>
" nnoremap à :belowright split term://zsh<CR>:resize 15<CR>A
nnoremap <Esc> <cmd>set hlsearch!<CR>
noremap <M-Esc> <cmd>NERDTreeFind<CR>
noremap <C-f> <cmd>GFiles<CR>
noremap <C-q> <cmd>Ag<CR>
" Close preview window
noremap tr <cmd>pc<CR>
noremap tw <cmd>Buffers<CR>
noremap tt <cmd>b#<CR>
noremap tq <cmd>bd<CR>
noremap tw <cmd>Buffers<CR>
noremap ts <cmd>GitGutterStageHunk<CR>
noremap tx <cmd>GitGutterUndoHunk<CR>
noremap ]h <cmd>GitGutterNextHunk<CR>
noremap [h <cmd>GitGutterPrevHunk<CR>
noremap tg <cmd>Git<CR>
noremap td <cmd>Gdiffsplit!<CR>
noremap tb <cmd>GBranches<CR>
noremap te <cmd>Git! fetch<CR>
noremap tf <cmd>execute "Git! pull " . FugitiveRemote().remote_name . " " . FugitiveHead()<CR>
noremap tp <cmd>execute "Git! push origin @:refs/heads/". FugitiveHead()<CR>
noremap th <cmd>echo "https://github.com/". substitute(g:fugitive#Remote().path, ".git", "", "") ."/blob/". FugitiveHead() ."/". expand("%") ."#L". line(".")<CR>

" Disable movement in insert mode
inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>

" Visual mode search
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

silent! exec "source " . argv(0) . "/.vimrc"
