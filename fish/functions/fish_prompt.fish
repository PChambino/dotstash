function fish_prompt
  set -l cyan (set_color -o cyan)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o brgreen)
  set -l dim (set_color -d)
  set -l normal (set_color normal)

  set -l host
  if test -n "$SSH_CLIENT"
    set host $green"ssh:($dim"(hostname)"$normal$green) "
  end

  set -l arrow "$red➜ "
  set -l cwd $cyan(basename (prompt_pwd))

  set -l git_info (__fish_git_prompt "%s")
  if test -n "$git_info"
    set git_info "$blue git:($git_info$blue)"
  end

  set -l gs_info $GS_NAME
  if test -n "$gs_info"
    set gs_info "$green (gs)"
  end

  echo -n -s $arrow $host $cwd $git_info $gs_info $normal " "
end
