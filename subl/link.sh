#!/bin/sh
set -e
if [ "$(uname)" != "Darwin" ]; then exit; fi

cd `dirname $0`
. ../scripts/link_file.sh

DIR="$HOME/Library/Application Support/Sublime Text 3/Packages/User"
mkdir -p "$DIR"
link_file `pwd`/Preferences.sublime-settings "$DIR"/Preferences.sublime-settings
link_file  "/Applications/Sublime Text.app/Contents/MacOS/Sublime Text" /usr/local/bin/subl
