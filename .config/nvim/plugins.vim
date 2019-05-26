if has('nvim') && !empty(glob('$XDG_DATA_HOME/nvim/site/autoload/plug.vim'))
    call plug#begin()

    " In buffer navigation
    Plug 'tpope/vim-unimpaired'
    Plug 'easymotion/vim-easymotion'

    " File/buffer browsing and finding
    Plug 'ctrlpvim/ctrlp.vim'

    " Source Control
    Plug 'tpope/vim-fugitive'

    " Clipboard
    Plug 'vim-scripts/YankRing.vim'

    " Completion
    Plug 'ervandew/supertab'
    Plug 'davidhalter/jedi-vim'

    " Linters/Formatters
    " Plug 'neomake/neomake'
    Plug 'w0rp/ale'
    Plug 'python/black'
    Plug 'Vimjas/vim-python-pep8-indent'

    " File types
    Plug 'chrisbra/csv.vim'
    Plug 'mboughaba/i3config.vim'

    " Bars
    Plug 'majutsushi/tagbar'
    Plug 'vim-airline/vim-airline'
    Plug 'vim-airline/vim-airline-themes'

    call plug#end()
endif


" Airline
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='base16_solarized'
let g:airline_powerline_fonts = 1
let g:airline_solarized_bg='dark'
let g:airline_section_z='%#__accent_bold#%{g:airline_symbols.linenr}%4l%#__restore__#%#__accent_bold#/%L%{g:airline_symbols.maxlinenr}%#__restore__# :%3v'

" Ale
let g:ale_echo_msg_error_str = 'E'
let g:ale_echo_msg_warning_str = 'W'
let g:ale_echo_msg_format = '[%linter%(%severity%)] %code%: %s'

" Black
let g:black_linelength = 80
let g:black_skip_string_normalization = 1

" Ctrl-P
let g:ctrlp_wildignore = 1

" Python PEP8 Indent
let g:pymode_indent = 0

" Sort from Top to Bottom
let g:ctrlp_match_window_reversed = 0
let g:ctrlp_match_window = 'bottom,order:ttb,min:1,max:16,results:32'
"let g:ctrlp_map = '<C-p>'
"let g:ctrlp_cmd = 'CtrlPMixed'
let g:ctrlp_cmd = 'CtrlPMRUFiles'
let g:ctrlp_working_path_mode = 'r'
let g:ctrlp_regexp = 1
"let g:ctrlp_dotfiles = 0

" Set this to 0 to enable cross-session caching by not deleting the cache files
" upon exiting Vim
let g:ctrlp_clear_cache_on_exit = 1
let g:ctrlp_max_height = 15
let g:ctrlp_user_command = {
    \     'types': {
    \         1: ['.git', 'cd %s && git ls-files'],
    \         2: ['.svn', 'svn ls -R'],
    \         3: ['.hg', 'hg --cwd %s locate -I .'],
    \     },
    \ 'fallback': 'find %s -type f',
    \ 'ignore': 0
    \ }
let g:ctrlp_mruf_exclude = '.*/.git/rebase-merge/git-rebase-todo\|.*/.git/COMMIT_EDITMSG'

" YankRing
let g:yankring_history_dir = $XDG_CACHE_HOME
let g:yankring_replace_n_pkey="<C-;>"
let g:yankring_min_element_length = 3
nnoremap <silent> <F11> :YRShow<CR>
