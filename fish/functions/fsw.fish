function fsw
  clear
  and $argv
  and fswatch -o . -l 1 | xargs -n1 sh -c "clear; $argv"
end
