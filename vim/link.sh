#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.vim/autoload
link_file `pwd`/plug.vim ~/.vim/autoload/plug.vim
link_file `pwd`/vimrc ~/.vimrc
