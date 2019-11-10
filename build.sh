#!/usr/bin/env bash

set -euxo pipefail

BUILD=/tmp/build
PKGS=seankhliao-arch-repo
REPO=seankhliao
EXT=pkg.tar.zst

[[ -d $PKGS ]] || sudo mkdir $PKGS

mkdir $BUILD
HOME=/tmp
yay -S --noconfirm --builddir $BUILD --batchinstall \
    downgrade \
    google-chrome-dev \
    google-chrome \
    kubernetes-helm-git \
    neovim-plug-git \
    tag-ag \
    wl-clipboard \
    yay-bin

for p in $BUILD/*.$EXT; do
    sudo cp -v $p/*.$EXT $PKGS/
done

sudo repo-add -R $PKGS/$REPO.db.tar.zst $PKGS/*.$EXT
