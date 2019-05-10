#if [[ $EUID -ne 0 ]]; then
#    LANG=en_US.UTF-8
#    LANG=en_US.ISO-8859-1
#fi

umask 022
limit coredumpsize 800M

export DOC=/usr/share/doc
export USA_RESIDENT=YES
export RSYNC_RSH=ssh
export ZINITDIR=$HOME/.zsh.d
export XDG_CONFIG_HOME="$HOME/.config"
export XDG_DATA_HOME="$HOME/.local/share"
export XDG_CACHE_HOME="$HOME/.cache"

local _fpath="$ZINITDIR/functions"
fpath=($fpath $_fpath)
autoload -U $_fpath/*(:t)

export EDITOR='vim'
export ALTERNATE_EDITOR='vi'

if [[ -d $HOME/local/lib ]]; then
    export LD_LIBRARY_PATH=$HOME/local/lib
fi
