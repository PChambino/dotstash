#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.vim
link_file `pwd`/autoload ~/.vim/autoload
link_file `pwd`/ftplugin ~/.vim/ftplugin
link_file `pwd`/vimrc ~/.vimrc
