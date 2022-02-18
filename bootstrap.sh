#!/bin/sh

set -e

case $(uname) in
    Darwin)
        homebrew/install.sh
        python/install.sh
        ;;
    Linux)
        sudo apt install -y software-properties-common
        sudo apt-add-repository -y ppa:fish-shell/release-3
        sudo apt-add-repository -y ppa:git-core/ppa
        sudo apt update
        # force-overwrite: https://github.com/sharkdp/bat/issues/938
        sudo apt install -y \
            -o Dpkg::Options::="--force-overwrite" \
            fish tmux neovim git colordiff silversearcher-ag ripgrep bat
        ;;
esac

for SCRIPT in */link.sh; do $SCRIPT; done
