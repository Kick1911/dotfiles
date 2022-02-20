" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
call plug#begin('~/.vim/plugged')

" Make sure you use single quotes

" ---
Plug 'Kick1911/nerdtree'  " NERD Tree
Plug 'Xuyuanp/nerdtree-git-plugin'  " show git status in Nerd tree
Plug 'vim-airline/vim-airline' " UI
Plug 'vim-airline/vim-airline-themes' " Themes
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'stsewd/fzf-checkout.vim'
" Plug 'Shougo/deoplete.nvim', { 'do': ':UpdateRemotePlugins' }
Plug 'numirias/semshi', {'do': ':UpdateRemotePlugins'} " Fast Python linter
Plug 'neoclide/coc.nvim' " coc.nvim C syntax
" Plug 'sheerun/vim-polyglot'
" Plug 'rking/ag.vim' " Text search
" Plug 'Chun-Yang/vim-action-ag' " Ag compliment
" Plug 'rafi/awesome-vim-colorschemes'

" Code {{{
Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
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
setlocal foldmethod=syntax

" https://github.com/rafi/awesome-vim-colorschemes
" colorscheme dogrun

" Default colour of line number
hi LineNr ctermfg=blue
hi Search cterm=NONE ctermfg=red ctermbg=lightgreen
hi CocFloating ctermfg=red ctermbg=black
hi ColorColumn ctermbg=131
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
tnoremap <Esc> <C-\><C-n>
nnoremap <C-e> <C-u>
" nnoremap à :belowright split term://zsh<CR>:resize 15<CR>A
nnoremap <Esc> :set hlsearch!<CR>
noremap gr gT
noremap <M-Esc> :NERDTreeFind<CR>
noremap <C-f> :GFiles<CR>
noremap <C-a> :Ag<CR>
noremap tw :Buffers<CR>
noremap tt :b#<CR>
noremap tq :bd<CR>
noremap tw :Buffers<CR>
noremap ts :GitGutterStageHunk<CR>
noremap tx :GitGutterUndoHunk<CR>
noremap ]h :GitGutterNextHunk<CR>
noremap [h :GitGutterPrevHunk<CR>
noremap tg :Git<CR>
noremap td :Gdiffsplit!<CR>
noremap tb :GBranches<CR>
noremap tf :Git fetch<CR>

" Disable movement in insert mode
inoremap <up> <NOP>
inoremap <down> <NOP>
inoremap <left> <NOP>
inoremap <right> <NOP>

" Visual mode search
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

