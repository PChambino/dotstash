if [ -e /opt/homebrew/bin/brew ]
  eval (/opt/homebrew/bin/brew shellenv)
end

if [ -e /Applications/SnowSQL.app ]
  addtopath /Applications/SnowSQL.app/Contents/MacOS
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

if [ -e ~/projects/carwow/dev-environment ]
  addtopath ~/projects/carwow/dev-environment/bin
end

addtopath ~/.local/bin
addtopath bin
