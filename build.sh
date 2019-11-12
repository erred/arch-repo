#!/usr/bin/env bash

set -euxo pipefail

BUILD=/tmp/build
PKGS=seankhliao-arch-repo
REPO=seankhliao
EXT=pkg.tar.zst

[[ -d $PKGS ]] || sudo mkdir $PKGS

mkdir $BUILD
HOME=/tmp
yay -Syu --noconfirm --builddir $BUILD --batchinstall \
    dockerfile-language-server-bin \
    downgrade \
    go-git \
    google-chrome-dev \
    google-chrome \
    javascript-typescript-langserver \
    kitty-git \
    kubernetes-helm-git \
    microsoft-python-language-server \
    neovim-git \
    neovim-plug-git \
    tag-ag \
    vscode-css-languageserver-bin \
    vscode-html-languageserver-bin \
    vscode-json-languageserver-bin \
    wl-clipboard-x11 \
    xml-language-server-git \
    yaml-language-server-bin \
    yay-bin \
    zsh-completions-git

for p in $BUILD/*; do
    sudo cp -v $p/*.$EXT $PKGS/
done

sudo repo-add -R $PKGS/$REPO.db.tar.zst $PKGS/*.$EXT
