#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.config/ghostty
link_file `pwd`/config ~/.config/ghostty/config
