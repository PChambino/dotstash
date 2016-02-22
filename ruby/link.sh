#!/bin/sh
set -e
cd `dirname $0`
mkdir -p ~/.bundle
ln -si `pwd`/bundle/config ~/.bundle
ln -si `pwd`/rubocop.yml ~/.rubocop.yml
