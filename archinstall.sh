#!/usr/bin/env bash

set -euxo pipefail

# inject:
#   OUTDIR
#   PKG

BUILD=/tmp/build
HOME=/tmp

mkdir $BUILD
[[ -d $OUTDIR ]] || sudo mkdir $OUTDIR

yay -Syu --noconfirm --builddir $BUILD --batchinstall $PKG
for p in $BUILD/*; do
    sudo cp -v $p/*.pkg.tar.zst $OUTDIR/
done

