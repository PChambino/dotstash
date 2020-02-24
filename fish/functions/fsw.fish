function fsw
  while true; do
    clear
    $argv
    fswatch -e .git -1 .
    sleep 1
  end
end
