#!/bin/bash
#
# bootstrap installs things.

set -e

source $HOME/.dotfiles/bin/print.sh

echo "Bootstrap terminal"
echo "------------------"
print_warning "This will reset your terminal configuration."
echo "Are you sure you want to continue? (y/n) "
read -p 'Answer: ' reply

if [[ $reply =~ ^[Yy]$ ]]; then
    print_status "Starting bootstrap process..."

    # Check for Command Line Developer Tools first
    print_status "Checking for Command Line Developer Tools..."
    if ! command -v git >/dev/null 2>&1 || ! xcode-select -p >/dev/null 2>&1; then
        print_warning "Command Line Developer Tools not found. Installing..."
        xcode-select --install
        print_status "Please complete the Command Line Developer Tools installation and run this script again."
        exit 0
    else
        print_status "Command Line Developer Tools are already installed"
    fi

    # Ask for password upfront
    sudo -v

    # Keep sudo alive
    while true; do sudo -n true; sleep 60; kill -0 "$$" || exit; done 2>/dev/null &

    if [ -f ~/.dotfiles/fresh.sh ]; then
        source ~/.dotfiles/fresh.sh
        print_status "Bootstrap completed successfully!"
    else
        print_error "fresh.sh not found!"
        exit 1
    fi
else
    print_status "Bootstrap cancelled."
fi
