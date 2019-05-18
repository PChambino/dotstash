set fish_greeting

for FILE in $HOME/.config/fish/config.d/*.fish
  source "$FILE"
end
