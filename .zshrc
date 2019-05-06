# Compatibility for older versions of zsh
source $ZINITDIR/compat/init

# auto source and add hooks from $ZINITDIR/hooks/<HOOKNAME>/
autoload -U add-zsh-hook
{
    local dir file
    for dir in $ZINITDIR/hooks/*(/); do
        for file in $dir/*; do
            source $file
            add-zsh-hook $dir:t $file:t
        done
    done
}

# source files in ZINITDIR
if [[ -d "$ZINITDIR" ]]; then
    local -aU zshd_files

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