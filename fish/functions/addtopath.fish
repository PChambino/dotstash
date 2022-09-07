function addtopath
  for value in $argv[-1..1] # reverse order since we are prepending
    set -gp fish_user_paths $value
  end
end
