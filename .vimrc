set nocompatible	" Use Vim defaults (much better!)
set backspace=2		" allow backspacing over everything in insert mode
set autoindent		" always set autoindenting on
set viminfo='20,\"50	" read/write a .viminfo file, don't store more than
			" 50 lines of registers
set history=1000	" 1000 lines of command line history
set textwidth=0
set wrapmargin=0
set autowrite
set splitbelow
set nohlsearch		" Highlight search
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set incsearch		" Incremental search
set hidden		" So you can open and edit a new file without saving the current
set laststatus=2
set ruler		" show the cursor position all the time
set nojoinspaces        " Don't use two spaces after period

" Indenting
"set tabstop=8
set softtabstop=8
set shiftwidth=8
set noexpandtab

set colorcolumn=80

" Wildmenu
set wildmenu
set wildmode=longest,list,full
"set t_Co=256 set term to 256 colors (seems to be not necessary)

" Copy/Paste
nnoremap <F5> :set invpaste paste?<Enter>
imap <F5> <C-O><F5>
set pastetoggle=<F5>
"set clipboard=unnamedplus

nnoremap <F6> "=strftime("%c")<CR>P
inoremap <F6> <C-R>=strftime("%c")<CR>


" Yankring
let g:yankring_history_dir = $XDG_CACHE_HOME
let g:yankring_replace_n_pkey="<C-;>"
let g:yankring_min_element_length = 3
nnoremap <silent> <F11> :YRShow<CR>

" Disable an enter ex-mode binding
map gQ <Nop>

" Use the other ex-mode binding to fill paragraph
map Q gwap

" Setup a search and replace from here to end-of-buffer
map <m-r> :.,$///gc<Left><Left><Left><Left>

" Window switch while still in interactive mode
imap <C-W><C-W> <Esc><C-W><C-W>

" Horizontal split - use <C-W>h
map <C-W>h <C-W>s
imap <C-W>h <Esc><C-W><C-W>s

" Close the current buffer without removing the window
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>.

" Folding
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc
set wildignore+=*.so,*.o,*.a
set wildignore+=*/.git/*,*/.hg/*,*/.svn/*

set complete=.,w,k

" Enable ftplugin
" http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean
filetype plugin indent on

" Display all buffers when online one tab opened
let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='dracula'
let g:airline_theme='base16_solarized'
let g:airline_powerline_fonts = 1
let g:airline_solarized_bg='dark'

if ! has('nvim')
	" Use pathogen to automatically load modules in ~/vim/bundle
	" https://github.com/tpope/vim-pathogen
	call pathogen#infect()
	"call pathogen#helptags()
else
call plug#begin()
	Plug 'ctrlpvim/ctrlp.vim'
	Plug 'ervandew/supertab'
	Plug 'vim-scripts/YankRing.vim'
	Plug 'easymotion/vim-easymotion'
	Plug 'tpope/vim-unimpaired'
	Plug 'tpope/vim-fugitive'
	Plug 'vim-syntastic/syntastic'
	Plug 'davidhalter/jedi-vim'
	Plug 'majutsushi/tagbar'
	Plug 'chrisbra/csv.vim'
	Plug 'mboughaba/i3config.vim'
	Plug 'vim-airline/vim-airline'
	Plug 'vim-airline/vim-airline-themes'

	" Completion
	" Plug 'roxma/nvim-yarp'
	" Plug 'ncm2/ncm2'
	" Plug 'ncm2/ncm2-bufword'
	" Plug 'ncm2/ncm2-tmux'
	" Plug 'ncm2/ncm2-path'
	" Plug 'ncm2/ncm2-jedi'
	" Plug 'ncm2/ncm2-pyclang'
call plug#end()
endif

" Completion
" Enable omnicomplete
" http://vim.wikia.com/wiki/Omni_completion
set ofu=syntaxcomplete#Complete

" ncm2
"let g:ncm2#matcher = 'substrfuzzy'
"set completeopt=noinsert,menuone,noselect
"autocmd BufEnter * call ncm2#enable_for_buffer()

" Enable Syntax highlighting
syntax on

" Syntastic provides syntax checking for a variety of file types using
" different backends for each. (ie: pylint for python)
let g:syntastic_check_on_open=1
let g:syntastic_mode_map = {
			\ 'mode': 'active',
			\ 'active_filetypes': [],
			\ 'passive_filetypes': ['c'] }
let g:syntastic_python_checkers = ['flake8']

" auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc
"command Reload checktime

"TAGS
set tags=./tags;
set nocst

" SH
autocmd BufNewFile,BufRead *.zsh.d/* setlocal filetype=zsh
autocmd BufNewFile,BufRead *.zsh setlocal filetype=zsh
autocmd BufNewFile,BufRead */comsh-scripts/sub/* setlocal filetype=sh

" MoinMoin (Wiki)
autocmd BufNewFile,BufRead *.moin setf moin

" Spell check
set spell
map <F7> :set spell!<Enter>

" Save your backups to a less annoying place than the current directory.
" If you have .vim-backup in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/backup or . if all else fails.
if isdirectory($HOME . '/.vim/backup') == 0
	:silent !mkdir -p ~/.vim/backup >/dev/null 2>&1
endif

" += means append, ^= means prepend
set backupdir-=.
set backupdir+=.
set backupdir-=~/
set backupdir^=~/.vim/backup/
set backupdir^=./.vim-backup/
set backup

" Save your swp files to a less annoying place than the current directory.
" If you have .vim-swap in the current directory, it'll use that.
" Otherwise it saves it to ~/.vim/swap, ~/tmp or .

if isdirectory($HOME . '/.vim/swap') == 0
	:silent !mkdir -p ~/.vim/swap >/dev/null 2>&1
endif

set directory=./.vim-swap//
set directory+=~/.vim/swap//
set directory+=~/tmp//
set directory+=.

if ! exists('g:colors_set') || ! g:colors_set
	let g:colors_set = 1
	set background=dark
	if ! has('nvim')
		let g:solarized_termcolors=256
		colorscheme solarized
	else
		colorscheme solarized8
	endif
endif

highlight link LongLine SpellBad
highlight link ExtraWhitespace SpellBad
match ExtraWhitespace /\(\s\+$\| \+\t\)/
autocmd BufWinEnter * highlight link ExtraWhitespace SpellBad

" Ctrl-P plugin config
" https://github.com/kien/ctrlp.vim/blob/master/doc/ctrlp.txt
" - This will use wildignore, so it's likely we don't want custom ignore stuff
"   configured here

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
			\ 'types': {
			\ 1: ['.git', 'cd %s && git ls-files'],
			\ 2: ['.svn', 'svn ls -R'],
			\ 3: ['.hg', 'hg --cwd %s locate -I .'],
			\ },
			\ 'fallback': 'find %s -type f',
			\ 'ignore': 0
			\ }
