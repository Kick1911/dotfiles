" Specify a directory for plugins
" - For Neovim: ~/.local/share/nvim/plugged
" - Avoid using standard Vim directory names like 'plugin'
lua require("imports")

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
setlocal foldmethod=indent
set mouse=

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

" nnoremap à :belowright split term://zsh<CR>:resize 15<CR>A


" Visual mode search
vnoremap // y/\V<C-R>=escape(@",'/\')<CR><CR>

silent! exec "source " . argv(0) . "/.vimrc"
