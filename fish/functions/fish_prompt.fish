function fish_prompt
  set -l cyan (set_color -o cyan)
  set -l red (set_color -o red)
  set -l blue (set_color -o blue)
  set -l green (set_color -o green)
  set -l normal (set_color normal)

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

  if test -e .git; and which hub > /dev/null
    set -l now (date +%s)
    set -l last (stat -f %m .git/ci-status 2> /dev/null; or echo 0)
    if test (expr $now - $last) -gt 30
      touch .git/ci-status
      switch (hub ci-status)
        case success
          set __fish_git_prompt_color_branch green
        case failure
          set __fish_git_prompt_color_branch red
        case pending
          set __fish_git_prompt_color_branch yellow
        case '*'
          set __fish_git_prompt_color_branch red
      end
    end
  end

  echo -n -s $arrow $cwd $git_info $gs_info $normal " "
end
