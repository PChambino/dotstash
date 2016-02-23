#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.bundle
link_file `pwd`/bundle/config ~/.bundle/config
link_file `pwd`/rubocop.yml ~/.rubocop.yml
