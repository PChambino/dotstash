#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.hammerspoon
link_file `pwd`/init.lua ~/.hammerspoon/init.lua
