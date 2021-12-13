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
        if [ $(id -nu) == "vscode" ]; then
            usermod -s $(which fish) vscode
        fi
        ;;
esac

for SCRIPT in */link.sh; do $SCRIPT; done
