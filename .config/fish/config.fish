# clear greeting message
set fish_greeting

# /usr/local/bin to top of the PATH
set PATH /usr/local/bin $PATH

# setup z
begin
  set -l Z ~/.config/fish/z.fish
  test -e $Z; and . $Z
end

# setup rbenv
if which rbenv > /dev/null
  set PATH ~/.rbenv/shims $PATH
  rbenv rehash > /dev/null ^&1
  function b
      bundle exec $argv
  end
end
