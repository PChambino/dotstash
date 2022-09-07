#!/bin/sh
set -e
cd `dirname $0`
if test ! -e /opt/homebrew/bin/brew; then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
/opt/homebrew/bin/brew install $(cat formulas.txt)
