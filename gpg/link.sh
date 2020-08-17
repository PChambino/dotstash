#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.gnupg
chmod 700 ~/.gnupg
link_file `pwd`/gpg-agent.conf ~/.gnupg/gpg-agent.conf
