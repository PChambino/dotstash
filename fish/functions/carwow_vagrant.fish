function carwow_vagrant
  set -l vagrant_dir

  if pwd | grep -q /projects/carwow/
    set vagrant_dir (pwd | sed '/.*\/projects\/carwow\//s///')
  end

  cd ~/vagrant
  git pull --ff

  if not vagrant status | grep -q running
    vagrant up --provision
  end

  if test -n "$vagrant_dir"
    vagrant ssh -c "CARWOW_VAGRANT_DIR=$vagrant_dir \$SHELL"
  else
    vagrant ssh
  end
end
