if !exists('$XDG_CONFIG_HOME')
    let $XDG_CONFIG_HOME=glob('$HOME').'/.config/'
    echo '$XDG_CONFIG_HOME is unset, defaulting to '.glob('$XDG_CONFIG_HOME')

endif

if !exists('$XDG_DATA_HOME')
    let $XDG_DATA_HOME=glob('$HOME').'/.local/share/'
    echo '$XDG_DATA_HOME is unset, defaulting to '.glob('$XDG_DATA_HOME')
endif

if !isdirectory($XDG_CONFIG_HOME)
    silent !mkdir -p "$XDG_CONFIG_HOME"
endif

if !isdirectory($XDG_CONFIG_HOME)
    silent !mkdir -p "$XDG_DATA_HOME"
endif


if !has('nvim')
    set nocompatible
    set incsearch		" Incremental search
    set hlsearch

    silent !mkdir -p "$XDG_DATA_HOME/nvim/swap"
    silent !mkdir -p "$XDG_DATA_HOME/nvim/backup"
    silent !mkdir -p "$XDG_DATA_HOME/nvim/shada"

    set directory=/$XDG_DATA_HOME/nvim/swap
    set backupdir=.,$XDG_DATA_HOME/nvim/backup
    set viminfo+=n$XDG_DATA_HOME/nvim/shada/viminfo

    " Wildmenu for command line completion
    set wildmenu
    set wildmode=longest,list,full

    " Copy/Paste
    nnoremap <F5> :set invpaste paste?<Enter>
    imap <F5> <C-O><F5>
    set pastetoggle=<F5>
endif


set backspace=2		" allow backspacing over everything in insert mode
set autoindent		" always set autoindenting on
set history=1000	" 1000 lines of command line history
set textwidth=0
set wrapmargin=0
set autowrite
set splitbelow
set showcmd		" Show (partial) command in status line.
set showmatch		" Show matching brackets.
set hidden		" So you can open and edit a new file without saving the current
set laststatus=2
set ruler		" show the cursor position all the time
set nojoinspaces        " Don't use two spaces after period

" Indenting - By default tabs will be tabs
set softtabstop=8
set shiftwidth=8
set noexpandtab

set colorcolumn=80

"set t_Co=256 set term to 256 colors (seems to be not necessary)

"set clipboard=unnamedplus

nnoremap <F6> "=strftime("%c")<CR>P
inoremap <F6> <C-R>=strftime("%c")<CR>

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
map <leader>q :bp<bar>sp<bar>bn<bar>bd<CR>

map <leader>n :bnext<CR>
map <leader>p :bprev<CR>

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

" Completion
set complete=.,w,k
" Enable omnicomplete
" http://vim.wikia.com/wiki/Omni_completion
set ofu=syntaxcomplete#Complete

" Enable Syntax highlighting
syntax on

" TAGS
set tags=./tags;
set nocst

" Spell check
set spell
map <F7> :set spell!<Enter>

"
" Colors
"
if ! exists('g:colors_set') || ! g:colors_set
	let g:colors_set = 1
	set background=dark
	if !has('nvim')
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

" Enable ftplugin
" http://vim.wikia.com/wiki/Keep_your_vimrc_file_clean
filetype plugin indent on

"
" Hooks based on file patterns
"
"

" Auto reload vimrc when editing it
autocmd! bufwritepost .vimrc source ~/.vimrc

" Set file types
autocmd BufNewFile,BufRead *.zsh.d/* setlocal filetype=zsh
autocmd BufNewFile,BufRead *.zsh setlocal filetype=zsh
autocmd BufNewFile,BufRead */comsh-scripts/sub/* setlocal filetype=sh
autocmd BufNewFile,BufRead *.moin setf moin


"
" Settings based on file type
"
au FileType vim set smarttab
au FileType vim set expandtab
au FileType vim set softtabstop=4
au FileType vim set shiftwidth=4
au FileType vim set textwidth=80
au FileType vim set formatoptions-=t

" Load and configure plugins in plugins.vim
runtime plugins.vim
