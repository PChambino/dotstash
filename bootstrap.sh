#!/bin/sh

set -e

case $(uname) in
    Darwin)
        homebrew/install.sh
        python/install.sh
	;;
    Linux)
        sudo apt install -y fish tmux neovim
	;;
esac

for SCRIPT in */link.sh; do $SCRIPT; done
