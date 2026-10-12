#!/bin/sh
set -e
cd `dirname $0`
. ../scripts/link_file.sh

mkdir -p ~/.terraform.d/plugin-cache
link_file `pwd`/terraformrc ~/.terraformrc
