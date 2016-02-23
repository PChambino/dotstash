#!/bin/sh
set -e
cd `dirname $0`
if test ! $(which brew); then
  /usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
brew install $(cat formulas.txt)
