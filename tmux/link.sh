#!/bin/sh
set -e
cd `dirname $0`
mkdir -p ~/.tmux/plugins/tpm
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
ln -si `pwd`/tmux.conf ~/.tmux.conf
