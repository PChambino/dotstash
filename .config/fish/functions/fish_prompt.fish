function fish_prompt

  if functions -q z
    z --add "$PWD"
  end

  set -l cyan (set_color -o cyan)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l normal (set_color normal)

  set -l arrow "$red➜ "
  set -l cwd $cyan(basename (prompt_pwd))

  set -l git_info (__fish_git_prompt "%s")
  if test -n "$git_info"
    set git_info "$blue git:($git_info$blue)"
  end

  echo -n -s $arrow $cwd $git_info $normal " "
end
