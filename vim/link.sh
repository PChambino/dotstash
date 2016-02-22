#!/bin/sh
set -e
cd `dirname $0`
mkdir -p ~/.vim/autoload
ln -si `pwd`/plug.vim ~/.vim/autoload
ln -si `pwd`/vimrc ~/.vimrc
