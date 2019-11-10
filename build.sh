#!/usr/bin/env bash

set -euxo pipefail

BUILD=/tmp/build

mkdir $BUILD
HOME=/tmp
yay -S --noconfirm --builddir $BUILD \
    downgrade \
    google-chrome-dev \
    google-chrome \
    kubernetes-helm-git \
    neovim-plug-git \
    tag-ag \
    wl-clipboard \
    yay-bin

[[ -d pkgs ]] || mkdir pkgs
for p in $BUILD/*; do
    cp -v $p/*.pkg.tar.zst pkgs/
done

repo-add -R pkgs/$REPO.db.tar.zst pkgs/*.pkg.tar.zst
# rm pkgs/$REPO.db pkgs/$REPO.files
# cp pkgs/$repo.db.tar.zst pkgs/$repo.db && cp pkgs/$repo.files.tar.zst pkgs/$repo.files
