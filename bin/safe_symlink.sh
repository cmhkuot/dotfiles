#!/bin/bash

source "$HOME/.dotfiles/bin/print.sh"

safe_symlink() {
  local source="$1"
  local target="$2"

  if [ ! -e "$source" ]; then
    print_error "Source file does not exist: $source"
    return 1
  fi

  if [ -L "$target" ]; then
    rm "$target"
    print_status "Removed existing symlink: $target"
  elif [ -e "$target" ]; then
    mv "$target" "$target.backup.$(date +%Y%m%d_%H%M%S)"
    print_warning "Backed up existing file: $target"
  fi

  ln -s "$source" "$target"
  print_status "Created symlink: $target -> $source"
}
