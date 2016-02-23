link_file () {
  local src=$1 dst=$2
  if [ "$(readlink "$dst")" = "$src" ]; then
    echo linked $dst
  else
    echo linking $dst
    ln -si "$src" "$dst" || true
  fi
}
