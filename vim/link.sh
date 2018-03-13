#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.vim
link_file `pwd`/after ~/.vim/after
link_file `pwd`/autoload ~/.vim/autoload
link_file `pwd`/ftplugin ~/.vim/ftplugin
link_file `pwd`/vimrc ~/.vimrc

mkdir -p ~/.config/nvim
link_file `pwd`/after ~/.config/nvim/after
link_file `pwd`/autoload ~/.config/nvim/autoload
link_file `pwd`/ftplugin ~/.config/nvim/ftplugin
link_file `pwd`/vimrc ~/.config/nvim/init.vim
