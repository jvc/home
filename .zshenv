#if [[ $EUID -ne 0 ]]; then
#    LANG=en_US.UTF-8
#    LANG=en_US.ISO-8859-1
#fi

umask 022
limit coredumpsize 800M

#export AWT_TOOLKIT=MToolkit
export DOC=/usr/share/doc
export USA_RESIDENT=YES
export RSYNC_RSH=ssh
export CVS_RSH=/usr/bin/ssh
export ZINITDIR=$HOME/.zsh.d
export PYTHONDOCS=/usr/share/doc/python/html/

local _fpath="$ZINITDIR/functions"
fpath=($fpath $_fpath)
autoload -U $_fpath/*(:t)

#export EDITOR='emacsclientterm'
export EDITOR='vim'
export ALTERNATE_EDITOR='vi'

if [[ -d $HOME/local/lib ]]; then
    export LD_LIBRARY_PATH=$HOME/local/lib
fi
