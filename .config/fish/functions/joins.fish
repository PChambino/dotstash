function joins --description 'Returns a string separated by the first argument' --argument separator
  set -e argv[1]
  echo -n $argv[1]; and for a in $argv[2..-1]; echo -n $separator$a; end
end
