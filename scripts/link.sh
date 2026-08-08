#!/bin/sh
set -e
cd `dirname $0`
. ./link_file.sh

mkdir -p ~/.local/bin
link_file `pwd`/wt-list ~/.local/bin/wt-list
link_file `pwd`/wt-preview ~/.local/bin/wt-preview
link_file `pwd`/claude-statusline ~/.local/bin/claude-statusline
link_file `pwd`/claude-usage ~/.local/bin/claude-usage
