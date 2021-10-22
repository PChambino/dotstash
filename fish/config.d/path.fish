if [ -e /Applications/SnowSQL.app ]
  addtopath /Applications/SnowSQL.app/Contents/MacOS
end

if which go > /dev/null
  addtopath ~/go/bin
end

if which ry > /dev/null
  addtopath /usr/local/lib/ruby/gems/2.7.0/bin
  addtopath /usr/local/lib/ry/current/bin
end

addtopath ~/.local/bin
addtopath bin
