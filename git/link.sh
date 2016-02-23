#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

link_file `pwd`/gitconfig ~/.gitconfig
link_file `pwd`/gitignore_global ~/.gitignore_global
