#!/bin/sh
set -e
if [ "$(uname)" != "Darwin" ]; then exit; fi

cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
link_file `pwd`/gpg-agent.conf ~/.gnupg/gpg-agent.conf
