#!/bin/sh
set -e
cd `dirname $0`
. ./link_file.sh

mkdir -p ~/.local/bin
link_file `pwd`/wt-list ~/.local/bin/wt-list
link_file `pwd`/wt-preview ~/.local/bin/wt-preview
