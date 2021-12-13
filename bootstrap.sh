#!/bin/sh

set -e

case $(uname) in
    Darwin)
        homebrew/install.sh
        python/install.sh
        ;;
    Linux)
        sudo apt install -y software-properties-common
        sudo apt-add-repository ppa:fish-shell/release-3
        sudo apt-add-repository ppa:git-core/ppa
        sudo apt install -y fish tmux neovim git colordiff
        ;;
esac

for SCRIPT in */link.sh; do $SCRIPT; done
