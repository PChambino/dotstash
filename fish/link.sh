#!/bin/sh
set -e
cd `dirname $0`
mkdir -p ~/.config/fish
ln -si `pwd`/config.fish ~/.config/fish
ln -si `pwd`/functions ~/.config/fish
