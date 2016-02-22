#!/bin/sh
set -e
cd `dirname $0`
/usr/bin/ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
brew install $(cat formulas.txt)
