#!/bin/sh

echo "Setting up your Mac..."

DOTFILES=$HOME/.dotfiles

# Hide "last login" line when starting a new terminal session
touch $HOME/.hushlogin

# Check for Oh My Zsh and install if we don't have it
if test ! $(which omz); then
  /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/HEAD/tools/install.sh)"
fi

# Check for Homebrew and install if we don't have it
if test ! $(which brew); then
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

  echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >>$HOME/.zprofile
  eval "$(/opt/homebrew/bin/brew shellenv)"
fi

# Removes .zshrc from $HOME (if it exists) and symlinks the .zshrc file from the .dotfiles
rm -rf $HOME/.zshrc
ln -s $DOTFILES/shell/.zshrc $HOME/.zshrc

# Update git config
git config --global init.defaultBranch main
git config --global help.autoCorrect prompt
# git config --global branch.sort -committerdate
git config --global fetch.prune true
git config --global log.date iso

# Add global gitignore
ln -s $DOTFILES/.gitignore.global $HOME/.gitignore.global
git config --global core.excludesfile $HOME/.gitignore.global

# Create a directory for global packages and tell npm where to store globally installed packages
mkdir "${HOME}/.npm-packages"
npm config set prefix "${HOME}/.npm-packages"

# Update Homebrew recipes
brew update

# Install all our dependencies with bundle (See Brewfile)
brew tap homebrew/bundle
brew bundle --file $DOTFILES/macos/Brewfile

# Set default MySQL root password and auth type
# mysql -u root -e "ALTER USER root@localhost IDENTIFIED WITH mysql_native_password BY 'password'; FLUSH PRIVILEGES;"

# Create a projects directories
mkdir $HOME/Code

# Symlink the Mackup config file to the home directory
ln -s $DOTFILES/macos/.mackup.cfg $HOME/.mackup.cfg

# Symlink the npm default packages file to the nvm directory
if test -d $HOME/.nvm; then
  ln -s $DOTFILES/npm-default-packages $HOME/.nvm/default-packages
fi

# Set macOS preferences - we will run this last because this will reload the shell
source $DOTFILES/macos/set-defaults.sh
