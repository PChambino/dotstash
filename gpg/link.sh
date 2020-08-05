#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.gnupg
link_file `pwd`/gpg.conf ~/.gnupg/gpg.conf
