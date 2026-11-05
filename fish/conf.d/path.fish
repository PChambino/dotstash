if [ -e /opt/homebrew/bin/brew ]
  # eval (/opt/homebrew/bin/brew shellenv)
  set -gx HOMEBREW_PREFIX /opt/homebrew
  set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
  set -gx HOMEBREW_REPOSITORY /opt/homebrew
  fish_add_path -g /opt/homebrew/bin /opt/homebrew/sbin
  set -gp MANPATH /opt/homebrew/share/man
  set -gp INFOPATH /opt/homebrew/share/info
end

if [ -e /opt/homebrew/opt/ruby/bin ]
  fish_add_path -g /opt/homebrew/opt/ruby/bin
  fish_add_path -g (gem env home)/bin
end

if [ (which ry) = /opt/homebrew/bin/ry ]
  fish_add_path -g /opt/homebrew/lib/ry/current/bin
end

fish_add_path -g /opt/homebrew/opt/openjdk/bin
fish_add_path -g ~/.capsem/bin
fish_add_path -g ~/.google-cloud-sdk/bin
fish_add_path -g ~/.local/bin
fish_add_path -g ~/go/bin

if [ -e ~/Code/carwow/dev-environment ]
  fish_add_path -g ~/Code/carwow/dev-environment/bin
  set -p fish_complete_path ~/Code/carwow/dev-environment/completions
end

set -gp fish_user_paths bin
