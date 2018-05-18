function carwow_vagrant
  set -l vagrant_dir

  if pwd | grep -q /projects/carwow/
    set vagrant_dir (pwd | sed '/.*\/projects\/carwow\//s///')
  end

  cd ~/vagrant
  git fetch
  git log --oneline origin/master...
  set -l should_provision (git log --oneline origin/master...)
  git merge --ff-only

  if not vagrant status | grep -q running
    vagrant up
  end

  if test -n "$should_provision"
    vagrant provision
  end

  if test -n "$vagrant_dir"
    vagrant ssh -c "CARWOW_VAGRANT_DIR=$vagrant_dir \$SHELL"
  else
    vagrant ssh
  end
end
