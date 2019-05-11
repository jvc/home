# Compatibility for older versions of zsh
source $ZINITDIR/compat/init

autoload -U add-zsh-hook

# Source and add hooks from $ZINITDIR/hooks/<HOOKNAME>/
load_hooks() {
    local dir file
    for dir in $ZINITDIR/hooks/*(/); do
        for file in $dir/*; do
            source $file
            add-zsh-hook $dir:t $file:t
        done
    done
}

# Source files in ZINITDIR
load_zshd() {
    local file
    local -aU zshd_files

    if [[ -d "$ZINITDIR" ]]; then
        # load ALL CAPS first - this is kind of chintzy
        setopt pushd_silent
        pushd $ZINITDIR && {
            zshd_files=(
                [A-Z]*(^/)
                [^A-Z]*(^/)
            )

            for file in $zshd_files; do
                if ! source $file; then
                    print "Error in $file"
                fi
            done
            popd
        }
    fi
}

load_hooks
load_zshd
