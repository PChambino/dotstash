# clear greeting message
set fish_greeting

# ensure key bindings is set (?)
set fish_key_bindings fish_default_key_bindings

for FILE in $HOME/.config/fish/config.d/*.fish
  source "$FILE"
end
