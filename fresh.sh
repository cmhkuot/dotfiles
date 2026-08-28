#!/bin/bash

DOTFILES=$HOME/.dotfiles
source $DOTFILES/bin/print.sh
source $DOTFILES/bin/safe_symlink.sh
source $DOTFILES/bin/preflight.sh

DRY_RUN=false
if [ "$1" = "--dry-run" ]; then
  DRY_RUN=true
fi

# Manual actions collected during the run, printed together at the end so they
# do not scroll away mid-install
NEXT_STEPS=()

# One "OK|<label>" or "FAIL|<label>" entry per step, in run order
RESULTS=()

run_step() {
  local label="$1"
  shift
  if "$@"; then
    RESULTS+=("OK|$label")
  else
    RESULTS+=("FAIL|$label")
  fi
}

step_hushlogin() {
  # Hide "last login" line when starting a new terminal session
  touch "$HOME/.hushlogin"
}

step_ohmyzsh() {
  if ! command -v omz >/dev/null 2>&1; then
    print_status "Installing Oh My Zsh..."
    RUNZSH=no /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)" || {
      print_error "Failed to install Oh My Zsh"
      return 1
    }
    print_status "Oh My Zsh installed successfully"
  else
    print_status "Oh My Zsh is already installed"
  fi
}

step_zsh_plugins() {
  local zsh_custom_plugins="$DOTFILES/shell/plugins"
  local failures=0

  if [ ! -d "$zsh_custom_plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$zsh_custom_plugins/zsh-autosuggestions" || { print_warning "Failed to clone zsh-autosuggestions"; failures=$((failures + 1)); }
  else
    print_status "zsh-autosuggestions already exists"
  fi

  if [ ! -d "$zsh_custom_plugins/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$zsh_custom_plugins/zsh-syntax-highlighting" || { print_warning "Failed to clone zsh-syntax-highlighting"; failures=$((failures + 1)); }
  else
    print_status "zsh-syntax-highlighting already exists"
  fi

  if [ ! -d "$zsh_custom_plugins/zsh-nvm" ]; then
    git clone https://github.com/lukechilds/zsh-nvm "$zsh_custom_plugins/zsh-nvm" || { print_warning "Failed to clone zsh-nvm"; failures=$((failures + 1)); }
  else
    print_status "zsh-nvm already exists"
  fi

  if [ ! -d "$zsh_custom_plugins/zsh-you-should-use" ]; then
    git clone https://github.com/MichaelAquilina/zsh-you-should-use "$zsh_custom_plugins/zsh-you-should-use" || { print_warning "Failed to clone zsh-you-should-use"; failures=$((failures + 1)); }
  else
    print_status "zsh-you-should-use already exists"
  fi

  if [ ! -d "$zsh_custom_plugins/yarn-autocompletions" ]; then
    git clone https://github.com/g-plane/zsh-yarn-autocompletions "$zsh_custom_plugins/yarn-autocompletions" || { print_warning "Failed to clone yarn-autocompletions"; failures=$((failures + 1)); }
  else
    print_status "yarn-autocompletions already exists"
  fi

  [ "$failures" -eq 0 ]
}

step_homebrew() {
  if ! command -v brew >/dev/null 2>&1; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
      print_error "Failed to install Homebrew"
      return 1
    }
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>"$HOME/.zprofile"
    eval "$(/opt/homebrew/bin/brew shellenv)"
    print_status "Homebrew installed successfully"
  else
    print_status "Homebrew is already installed"
  fi
}

step_shell_config() {
  safe_symlink "$DOTFILES/shell/.zshrc" "$HOME/.zshrc"
}

step_git_config() {
  git config --global init.defaultBranch main
  git config --global pull.rebase false
  git config --global fetch.prune true
  git config --global log.date iso
  git config --global help.autoCorrect prompt
  git config --global credential.helper osxkeychain
  git config --global difftool.sourcetree.cmd 'opendiff "$LOCAL" "$REMOTE"'
  git config --global mergetool.sourcetree.cmd '/Applications/Sourcetree.app/Contents/Resources/opendiff-w.sh "$LOCAL" "$REMOTE" -ancestor "$BASE" -merge "$MERGED"'
  git config --global mergetool.sourcetree.trustExitCode true
}

step_git_identity() {
  if [ -n "$(git config --global user.name)" ] && [ -n "$(git config --global user.email)" ]; then
    print_status "Git user.name/user.email already configured"
    return
  fi

  read -p 'Git user.name: ' git_name
  read -p 'Git user.email: ' git_email
  git config --global user.name "$git_name"
  git config --global user.email "$git_email"
  print_status "Git identity set to $git_name <$git_email>"
}

step_npmrc() {
  safe_symlink "$DOTFILES/config/npmrc" "$HOME/.npmrc"
}

step_yarnrc() {
  safe_symlink "$DOTFILES/config/yarnrc.yml" "$HOME/.yarnrc.yml"
}

step_htop() {
  mkdir -p "$HOME/.config/htop"
  safe_symlink "$DOTFILES/config/htop/htoprc" "$HOME/.config/htop/htoprc"
}

step_copilot_config() {
  mkdir -p "$HOME/.copilot"
  safe_symlink "$DOTFILES/config/copilot/settings.json" "$HOME/.copilot/settings.json"
  safe_symlink "$DOTFILES/config/copilot/permissions-config.json" "$HOME/.copilot/permissions-config.json"
}

step_gh_extensions() {
  if ! command -v gh >/dev/null 2>&1; then
    print_warning "gh not found, skipping extension install"
    return
  fi

  local extensions_file="$DOTFILES/config/gh/extensions.txt"
  if [ ! -f "$extensions_file" ]; then
    print_warning "config/gh/extensions.txt not found"
    return
  fi

  local failures=0
  local repo
  while IFS= read -r repo; do
    [ -z "$repo" ] && continue
    case "$repo" in \#*) continue ;; esac

    if gh extension list 2>/dev/null | grep -q "$repo"; then
      print_status "gh extension $repo already installed"
    else
      gh extension install "$repo" || { print_warning "Failed to install gh extension $repo"; failures=$((failures + 1)); }
    fi
  done <"$extensions_file"

  [ "$failures" -eq 0 ]
}

step_gitignore() {
  safe_symlink "$DOTFILES/.gitignore.global" "$HOME/.gitignore.global"
  git config --global core.excludesfile "$HOME/.gitignore.global"
}

step_brew_update() {
  brew update || { print_warning "Failed to update Homebrew"; return 1; }
}

step_dev_dir() {
  if [ ! -d "$HOME/dev" ]; then
    mkdir -p "$HOME/dev"
    print_status "Created dev directory"
  else
    print_status "dev directory already exists"
  fi
}

step_brewfile() {
  if [ ! -f "$DOTFILES/macos/Brewfile" ]; then
    print_error "Brewfile not found at $DOTFILES/macos/Brewfile"
    return 1
  fi

  brew bundle --file "$DOTFILES/macos/Brewfile" || print_warning "Some Brewfile installations may have failed"
  print_status "Finished installing from Brewfile"

  if command -v pyenv >/dev/null 2>&1; then
    print_step "Installing latest Python with pyenv..."
    local latest_python
    latest_python=$(pyenv install --list | grep -E '^  [0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
    if [ -n "$latest_python" ]; then
      pyenv install -s "$latest_python"
      pyenv global "$latest_python"
      print_status "Set global Python version to $latest_python via pyenv"
    else
      print_warning "Could not determine latest Python version for pyenv"
    fi
    export PATH="$HOME/.pyenv/shims:$PATH"
    hash -r
    print_status "Python version: $(python --version 2>&1)"
    print_status "Pip version: $(pip --version 2>&1)"
  else
    print_warning "pyenv not found after Brewfile install, skipping pyenv Python setup"
  fi
}

step_nvm_default_packages() {
  if [ -d "$HOME/.nvm" ]; then
    if [ -f "$DOTFILES/npm-default-packages" ]; then
      safe_symlink "$DOTFILES/npm-default-packages" "$HOME/.nvm/default-packages"
    else
      print_warning "npm-default-packages file not found"
    fi
  else
    print_warning "NVM directory not found, skipping default packages setup"
  fi
}

step_node_nvm() {
  if command -v nvm >/dev/null 2>&1 || [ -s "$NVM_DIR/nvm.sh" ]; then
    if ! command -v nvm >/dev/null 2>&1; then
      export NVM_DIR="$HOME/.nvm"
      [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    fi

    print_status "Installing latest LTS Node.js..."
    nvm install --lts || { print_warning "Failed to install Node.js LTS"; return 1; }
    nvm use --lts || print_warning "Failed to switch to Node.js LTS"
    nvm alias default lts/* || print_warning "Failed to set default Node.js version"

    print_status "Node.js $(node --version) installed and set as default"
  else
    print_warning "NVM not found, skipping Node.js installation"
  fi
}

step_ghostty() {
  local ghostty_source="$DOTFILES/config/ghostty/config"
  local ghostty_target="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
  safe_symlink "$ghostty_source" "$ghostty_target"
}

step_topgrade() {
  mkdir -p "$HOME/.config"
  local topgrade_source="$DOTFILES/config/topgrade.toml"
  local topgrade_target="$HOME/.config/topgrade.toml"
  safe_symlink "$topgrade_source" "$topgrade_target"
}

step_open_webui() {
  local webui_dir="$DOTFILES/config/open-webui"
  local webui_data_dir="$HOME/.local/share/open-webui"

  if [ ! -f "$webui_dir/.env" ]; then
    cp "$webui_dir/.env.example" "$webui_dir/.env"
    # JWT signing key: losing it invalidates every session
    local secret
    secret=$(openssl rand -hex 32)
    sed -i '' "s|^WEBUI_SECRET_KEY=.*|WEBUI_SECRET_KEY=$secret|" "$webui_dir/.env"
    chmod 600 "$webui_dir/.env"
    print_status "Generated $webui_dir/.env"
  else
    print_status "Open WebUI .env already exists"
  fi

  mkdir -p "$webui_data_dir"

  if command -v ollama >/dev/null 2>&1; then
    brew services start ollama || print_warning "Failed to start ollama service"
  else
    print_warning "ollama not found, skipping"
  fi

  if command -v orb >/dev/null 2>&1; then
    orb start || print_warning "Failed to start OrbStack"
    docker compose -f "$webui_dir/compose.yml" up -d || { print_warning "Failed to start Open WebUI"; return 1; }
    print_status "Open WebUI available at http://localhost:11435"
    NEXT_STEPS+=("Pull the local models: grep -v '^#' $webui_dir/models.txt | grep . | xargs -n1 ollama pull")
    NEXT_STEPS+=("Restore Open WebUI admin settings: $DOTFILES/bin/webui-config.sh import")
  else
    print_warning "OrbStack not found, skipping Open WebUI"
  fi
}

step_macos_defaults() {
  if [ -f "$DOTFILES/macos/set-defaults.sh" ]; then
    source "$DOTFILES/macos/set-defaults.sh"
    print_status "macOS preferences applied"
  else
    print_warning "set-defaults.sh not found"
    return 1
  fi
}

echo "Setting up your Mac..."
echo "====================="

if [ ! -d "$DOTFILES" ]; then
  print_error "Dotfiles directory not found at $DOTFILES"
  exit 1
fi

preflight "$DOTFILES"
preflight_status=$?

if [ "$DRY_RUN" = true ]; then
  exit $preflight_status
fi

if [ $preflight_status -ne 0 ]; then
  print_error "Preflight failed, aborting."
  exit 1
fi

print_step "Checking Command Line Developer Tools..."
if ! command -v git >/dev/null 2>&1 || ! xcode-select -p >/dev/null 2>&1; then
  print_error "Command Line Developer Tools not found!"
  print_status "Please install with: xcode-select --install"
  exit 1
else
  print_status "Command Line Developer Tools are installed"
fi

run_step "Hide last login banner" step_hushlogin
run_step "Oh My Zsh" step_ohmyzsh
run_step "Zsh plugins" step_zsh_plugins
run_step "Homebrew" step_homebrew
run_step "Shell config symlink" step_shell_config
run_step "Git config" step_git_config
run_step "Git identity" step_git_identity
run_step "Global gitignore" step_gitignore
run_step "npm config symlink" step_npmrc
run_step "Yarn config symlink" step_yarnrc
run_step "htop config symlink" step_htop
run_step "Copilot CLI config symlink" step_copilot_config
run_step "gh extensions" step_gh_extensions
run_step "Homebrew update" step_brew_update
run_step "Dev directory" step_dev_dir
run_step "Brewfile + pyenv" step_brewfile
run_step "NVM default packages" step_nvm_default_packages
run_step "Node.js via NVM" step_node_nvm
run_step "Ghostty config symlink" step_ghostty
run_step "Topgrade config symlink" step_topgrade
run_step "Ollama + Open WebUI" step_open_webui
run_step "macOS defaults" step_macos_defaults

NEXT_STEPS+=("Restart your terminal to apply all changes")

echo
echo "=== Kết quả cài đặt ==="
fail_count=0
for r in "${RESULTS[@]}"; do
  status="${r%%|*}"
  label="${r#*|}"
  if [ "$status" = "FAIL" ]; then
    fail_count=$((fail_count + 1))
  fi
  printf "[%s] %s\n" "$status" "$label"
done

echo
print_step "Manual steps left to finish:"
for i in "${!NEXT_STEPS[@]}"; do
  echo "  $((i + 1)). ${NEXT_STEPS[$i]}"
done

if [ "$fail_count" -gt 0 ]; then
  exit 1
fi
exit 0
