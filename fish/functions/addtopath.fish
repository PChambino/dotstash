function addtopath
  for value in $argv
    set -gp fish_user_paths $value
  end
end
