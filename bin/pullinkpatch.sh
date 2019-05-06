#!/bin/zsh

srcdir=$ARBORROOT/linux
commit=$1

if [[ -z $commit ]]; then
	echo "Usage: $0 <commit>"
fi

tgtdir=$PWD
set -x
(cd $srcdir && git format-patch "$commit^..$commit" --stdout > $tgtdir/patch)
git am -p2 $tgtdir/patch && rm $tgtdir/patch
