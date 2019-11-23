#!/usr/bin/env bash

set -euxo pipefail

# inject:
#   OUTDIR
#   PKG

BUILD=/tmp/build
HOME=/tmp

mkdir $BUILD
[[ -d $OUTDIR ]] || sudo mkdir $OUTDIR

if [[ -d $PKG ]]; then
    cp -r $PKG $BUILD
    cd $BUILD/$PKG
    makepkg -s
else
    yay -Syu --noconfirm --builddir $BUILD --batchinstall $PKG
fi

for p in $BUILD/*; do
    sudo cp -v $p/*.pkg.tar.zst $OUTDIR/
done
