#!/bin/sh
set -e
cd `dirname $0`
DIR="~/Library/Application Support/Sublime Text 3/Packages/User"
mkdir -p "$DIR"
ln -si `pwd`/Preferences.sublime-settings "$DIR"
ln -si  "/Applications/Sublime Text.app/Contents/MacOS/Sublime Text" /usr/local/bin/subl
