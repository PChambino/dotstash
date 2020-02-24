function fsw
  clear
  $argv
  fswatch -l 2 -e .git -e '~$' -e '[0-9]$' -o . | xargs -o -IX $SHELL -c "clear; $argv"
end
