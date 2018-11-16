function box
  set -l command $argv
  if test -z "$command"
    set command '$SHELL'
  end

  set -l projects_dir
  if pwd | grep -q /box/projects/carwow/
    set projects_dir (pwd | sed '/.*\/box\/projects\/carwow\//s///')
  end

  ssh -t box "cd /projects/carwow/$projects_dir && bash -lc '$command'"
end
