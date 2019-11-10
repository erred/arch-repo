#!/usr/bin/env bash

set -euxo pipefail

BUILD=/tmp/build
PKGS=seankhliao-arch-repo
REPO=seankhliao
EXT=pkg.tar.zst

[[ -d $PKGS ]] || sudo mkdir $PKGS
for p in $PKGS/*.$EXT; do
    sudo ln -sf $p /var/cache/pacman/
done

mkdir $BUILD
HOME=/tmp
yay -S --noconfirm --builddir $BUILD --batchinstall --needed \
    downgrade \
    google-chrome-dev \
    google-chrome \
    kubernetes-helm-git \
    neovim-plug-git \
    tag-ag \
    wl-clipboard \
    yay-bin

for p in $BUILD/*; do
    sudo cp -v $p/*.$EXT $PKGS/
done

sudo repo-add -R $PKGS/$REPO.db.tar.zst $PKGS/*.$EXT
