function fsw
  while true; do
    clear
    $argv
    fswatch -1 .
    sleep 2
  end
end
