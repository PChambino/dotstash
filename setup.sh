#!/usr/bin/env bash

cd $(dirname $0)

for FILE in $(find . -path "./.*" -type f | cut -c2-)
do
  CMD="ln -sf \"$(pwd)${FILE}\" \"${HOME}${FILE}\""
  echo $CMD && [ $DRYRUN ] || eval $CMD
done

case $(uname) in
Darwin)
  SUBLIMETEXT3="${HOME}/Library/Application Support/Sublime Text 3"
;;
*)
  SUBLIMETEXT3="${HOME}/.config/sublime-text-3"
;;
esac

for FILE in $(find . -path "./Sublime Text 3*" -type f | cut -c17-)
do
  CMD="ln -sf \"$(pwd)${FILE}\" \"${SUBLIMETEXT3}${FILE}\""
  echo $CMD && [ $DRYRUN ] || eval $CMD
done
