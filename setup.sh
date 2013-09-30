#!/usr/bin/env bash

cd $(dirname $0)

find . -path "./.*" -type f -not -path "./.git/*" | cut -c2- | \
  xargs -t -I % ln -sf "$(pwd)%" "$HOME%"

case $(uname) in
Darwin)
  SUBLIMETEXT3="$HOME/Library/Application Support/Sublime Text 3"
;;
*)
  SUBLIMETEXT3="$HOME/.config/sublime-text-3"
;;
esac

find . -path "./Sublime Text 3*" -type f | cut -c17- | \
  xargs -t -I % ln -sf "$(pwd)/Sublime Text 3%" "${SUBLIMETEXT3}%"
