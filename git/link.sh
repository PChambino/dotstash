#!/bin/sh
set -e
cd `dirname $0`
ln -si `pwd`/gitconfig ~/.gitconfig
ln -si `pwd`/gitignore_global ~/.gitignore_global
