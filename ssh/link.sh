#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.ssh/sockets
link_file `pwd`/config ~/.ssh/config
