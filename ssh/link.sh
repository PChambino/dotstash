#!/bin/sh
set -e
cd `dirname $0`
mkdir -p ~/.ssh
ln -si `pwd`/config ~/.ssh
