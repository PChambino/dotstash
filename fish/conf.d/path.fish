if [ -e /opt/homebrew/bin/brew ]
  # eval (/opt/homebrew/bin/brew shellenv)
  set -gx HOMEBREW_PREFIX /opt/homebrew
  set -gx HOMEBREW_CELLAR /opt/homebrew/Cellar
  set -gx HOMEBREW_REPOSITORY /opt/homebrew
  addtopath /opt/homebrew/bin /opt/homebrew/sbin
  set -gp MANPATH /opt/homebrew/share/man
  set -gp INFOPATH /opt/homebrew/share/info
end

if [ -e /Applications/SnowSQL.app ]
  addtopath /Applications/SnowSQL.app/Contents/MacOS
end

if [ -e /opt/homebrew/opt/openjdk ]
  addtopath /opt/homebrew/opt/openjdk/bin
end

if [ -e ~/go/bin ]
  addtopath ~/go/bin
end

if [ -e /opt/homebrew/opt/ruby/bin ]
  addtopath /opt/homebrew/opt/ruby/bin
  addtopath (gem env path | string split :)
end

if [ (which ry) = /opt/homebrew/bin/ry ]
  addtopath /opt/homebrew/lib/ry/current/bin
end

if [ -e ~/Code/carwow/dev-environment ]
  addtopath ~/Code/carwow/dev-environment/bin
end

addtopath ~/.local/bin
addtopath bin
