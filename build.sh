#!/usr/bin/env bash

set -euxo pipefail

BUILD=/tmp/build
REPO=seankhliao

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

[[ -d pkgs ]] || sudo mkdir pkgs
for p in $BUILD/*; do
    sudo cp -v $p/*.pkg.tar.zst pkgs/
done

sudo repo-add -R pkgs/$REPO.db.tar.zst pkgs/*.pkg.tar.zst
