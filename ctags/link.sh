#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

link_file `pwd`/scala ~/.ctags
