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
    exa-git \
    go-git \
    google-chrome-dev \
    google-chrome \
    kitty-git \
    kubernetes-helm-git \
    neovim-git \
    neovim-plug-git \
    ripgrep-git \
    rsync-git \
    tag-ag \
    wl-clipboard-x11 \
    yay-bin \
    zsh-completions-git

for p in $BUILD/*; do
    sudo cp -v $p/*.$EXT $PKGS/
done

sudo repo-add -R $PKGS/$REPO.db.tar.zst $PKGS/*.$EXT
