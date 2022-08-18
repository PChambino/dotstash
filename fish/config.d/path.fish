if [ -e /opt/homebrew ]
  eval (/opt/homebrew/bin/brew shellenv)
end

if [ -e /Applications/SnowSQL.app ]
  addtopath /Applications/SnowSQL.app/Contents/MacOS
end

if which go > /dev/null
  addtopath ~/go/bin
end

if which ry > /dev/null
  if [ -e /opt/homebrew ]
    addtopath /opt/homebrew/Cellar/ruby/3.1.2/bin
    addtopath /opt/homebrew/lib/ry/current/bin
  else
    addtopath /usr/local/lib/ruby/gems/2.7.0/bin
    addtopath /usr/local/lib/ry/current/bin
  end
end

if [ -e ~/projects/carwow/dev-environment -a (uname -m) = "arm64" ]
  addtopath ~/projects/carwow/dev-environment/bin
end

addtopath ~/.local/bin
addtopath bin
