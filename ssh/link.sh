#!/bin/sh
set -e
if [ "$(uname)" != "Darwin" ]; then exit; fi

cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.ssh/sockets
link_file `pwd`/config ~/.ssh/config
