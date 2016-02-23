#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.tmux/plugins/tpm
if ! [ -e ~/.tmux/plugins/tpm/tpm ]; then
  git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi
link_file `pwd`/tmux.conf ~/.tmux.conf
