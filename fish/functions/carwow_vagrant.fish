function carwow_vagrant
  set -l vagrant_dir (basename (pwd))

  cd ~/vagrant

  if not vagrant status | grep -q running;
    vagrant up $argv
  end

  vagrant ssh -c "CARWOW_VAGRANT_DIR=$vagrant_dir \$SHELL"
end
