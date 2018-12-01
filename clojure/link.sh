#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.lein
link_file `pwd`/lein/profiles.clj ~/.lein/profiles.clj
