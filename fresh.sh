#!/bin/bash

set -e # Exit on any error

DOTFILES=$HOME/.dotfiles
source $DOTFILES/bin/print.sh
source $DOTFILES/bin/safe_symlink.sh

echo "Setting up your Mac..."
echo "====================="

# Validate dotfiles directory exists
if [ ! -d "$DOTFILES" ]; then
    print_error "Dotfiles directory not found at $DOTFILES"
    exit 1
fi

# Check for Command Line Developer Tools
print_step "Checking Command Line Developer Tools..."
if ! command -v git >/dev/null 2>&1 || ! xcode-select -p >/dev/null 2>&1; then
    print_error "Command Line Developer Tools not found!"
    print_status "Please install with: xcode-select --install"
    exit 1
else
    print_status "Command Line Developer Tools are installed"
fi

# Hide "last login" line when starting a new terminal session
touch $HOME/.hushlogin

print_step "Checking Oh My Zsh installation..."
if ! command -v omz >/dev/null 2>&1; then
    print_status "Installing Oh My Zsh..."
    RUNZSH=no /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)" || {
        print_error "Failed to install Oh My Zsh"
        exit 1
    }
    print_status "Oh My Zsh installed successfully"
else
    print_status "Oh My Zsh is already installed"
fi

# Clone Zsh plugins if not already present
print_step "Cloning Zsh plugins..."
ZSH_CUSTOM_PLUGINS="$DOTFILES/shell/plugins"

# zsh-autosuggestions
if [ ! -d "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$ZSH_CUSTOM_PLUGINS/zsh-autosuggestions" || print_warning "Failed to clone zsh-autosuggestions"
else
    print_status "zsh-autosuggestions already exists"
fi

# zsh-syntax-highlighting
if [ ! -d "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting" ]; then
    git clone https://github.com/zsh-users/zsh-syntax-highlighting "$ZSH_CUSTOM_PLUGINS/zsh-syntax-highlighting" || print_warning "Failed to clone zsh-syntax-highlighting"
else
    print_status "zsh-syntax-highlighting already exists"
fi

# zsh-nvm
if [ ! -d "$ZSH_CUSTOM_PLUGINS/zsh-nvm" ]; then
    git clone https://github.com/lukechilds/zsh-nvm "$ZSH_CUSTOM_PLUGINS/zsh-nvm" || print_warning "Failed to clone zsh-nvm"
else
    print_status "zsh-nvm already exists"
fi

# zsh-you-should-use
if [ ! -d "$ZSH_CUSTOM_PLUGINS/zsh-you-should-use" ]; then
    git clone https://github.com/MichaelAquilina/zsh-you-should-use "$ZSH_CUSTOM_PLUGINS/zsh-you-should-use" || print_warning "Failed to clone zsh-you-should-use"
else
    print_status "zsh-you-should-use already exists"
fi

# yarn-autocompletions
if [ ! -d "$ZSH_CUSTOM_PLUGINS/yarn-autocompletions" ]; then
    git clone https://github.com/g-plane/zsh-yarn-autocompletions "$ZSH_CUSTOM_PLUGINS/yarn-autocompletions" || print_warning "Failed to clone yarn-autocompletions"
else
    print_status "yarn-autocompletions already exists"
fi

# Check for Homebrew and install if we don't have it
print_step "Checking Homebrew installation..."
if ! command -v brew >/dev/null 2>&1; then
    print_status "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" || {
        print_error "Failed to install Homebrew"
        exit 1
    }

    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
    print_status "Homebrew installed successfully"
else
    print_status "Homebrew is already installed"
fi

# Create safe symlink for .zshrc
print_step "Setting up shell configuration..."
safe_symlink "$DOTFILES/shell/.zshrc" "$HOME/.zshrc"

# Update git config
git config --global init.defaultBranch main
git config --global help.autoCorrect prompt
# git config --global branch.sort -committerdate
git config --global fetch.prune true
git config --global log.date iso

# Add global gitignore
print_step "Setting up git configuration..."
safe_symlink "$DOTFILES/.gitignore.global" "$HOME/.gitignore.global"
git config --global core.excludesfile $HOME/.gitignore.global

# Update Homebrew recipes
print_step "Updating Homebrew..."
brew update || print_warning "Failed to update Homebrew"

# Create a projects directory
print_step "Creating Code directory..."
if [ ! -d "$HOME/Code" ]; then
    mkdir -p "$HOME/Code"
    print_status "Created Code directory"
else
    print_status "Code directory already exists"
fi

# Install all our dependencies with bundle (See Brewfile)
print_step "Installing applications and dependencies..."
if [ -f "$DOTFILES/macos/Brewfile" ]; then
    brew bundle --file "$DOTFILES/macos/Brewfile" || print_warning "Some Brewfile installations may have failed"
    print_status "Finished installing from Brewfile"

    # Check if pyenv is installed, then install latest Python and set global
    if command -v pyenv >/dev/null 2>&1; then
        print_step "Installing latest Python with pyenv..."
        latest_python=$(pyenv install --list | grep -E '^  [0-9]+\.[0-9]+\.[0-9]+$' | tail -1 | tr -d ' ')
        if [ -n "$latest_python" ]; then
            pyenv install -s "$latest_python"
            pyenv global "$latest_python"
            print_status "Set global Python version to $latest_python via pyenv"
        else
            print_warning "Could not determine latest Python version for pyenv"
        fi
        # Ensure pyenv shims are in PATH for this session
        export PATH="$HOME/.pyenv/shims:$PATH"
        hash -r
        # Show python and pip version
        print_status "Python version: $(python --version 2>&1)"
        print_status "Pip version: $(pip --version 2>&1)"
    else
        print_warning "pyenv not found after Brewfile install, skipping pyenv Python setup"
    fi
else
    print_error "Brewfile not found at $DOTFILES/macos/Brewfile"
fi

# Set up NVM default packages by creating a symlink if NVM and the default-packages file exist
print_step "Setting up NVM default packages..."
if [ -d "$HOME/.nvm" ]; then
    if [ -f "$DOTFILES/npm-default-packages" ]; then
        safe_symlink "$DOTFILES/npm-default-packages" "$HOME/.nvm/default-packages"
    else
        print_warning "npm-default-packages file not found"
    fi
else
    print_warning "NVM directory not found, skipping default packages setup"
fi

# Set up Node.js via NVM
print_step "Setting up Node.js via NVM..."
if command -v nvm >/dev/null 2>&1 || [ -s "$NVM_DIR/nvm.sh" ]; then
    # Load NVM if it's not already loaded
    if ! command -v nvm >/dev/null 2>&1; then
        export NVM_DIR="$HOME/.nvm"
        [ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && \. "/opt/homebrew/opt/nvm/nvm.sh"
    fi

    # Install latest LTS Node.js
    print_status "Installing latest LTS Node.js..."
    nvm install --lts || print_warning "Failed to install Node.js LTS"
    nvm use --lts || print_warning "Failed to switch to Node.js LTS"
    nvm alias default lts/* || print_warning "Failed to set default Node.js version"

    print_status "Node.js $(node --version) installed and set as default"
else
    print_warning "NVM not found, skipping Node.js installation"
fi

# Set up Ghostty config symlink
print_step "Setting up Ghostty config symlink..."
GHOSTTY_CONFIG_SOURCE="$DOTFILES/config/ghostty/config"
GHOSTTY_CONFIG_TARGET="$HOME/Library/Application Support/com.mitchellh.ghostty/config"
safe_symlink "$GHOSTTY_CONFIG_SOURCE" "$GHOSTTY_CONFIG_TARGET"

# Set up Topgrade config symlink
print_step "Setting up Topgrade config symlink..."
TOPGRADE_CONFIG_SOURCE="$DOTFILES/config/topgrade.toml"
TOPGRADE_CONFIG_TARGET="$HOME/.config/topgrade.toml"
safe_symlink "$TOPGRADE_CONFIG_SOURCE" "$TOPGRADE_CONFIG_TARGET"

# Set macOS preferences - we will run this last because this will reload the shell
print_step "Setting macOS preferences..."
if [ -f "$DOTFILES/macos/set-defaults.sh" ]; then
    source "$DOTFILES/macos/set-defaults.sh"
    print_status "macOS preferences applied"
else
    print_warning "set-defaults.sh not found"
fi

print_status "Setup completed successfully! 🎉"
print_status "Please restart your terminal to apply all changes."
