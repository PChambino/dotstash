#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.config/fish
link_file `pwd`/config.fish ~/.config/fish/config.fish
link_file `pwd`/config.d ~/.config/fish/config.d
link_file `pwd`/functions ~/.config/fish/functions
