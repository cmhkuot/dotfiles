#!/usr/bin/env zsh
#
# PATH configuration for development tools
#

# Helper function to add to PATH if directory exists
path_add() {
    if [ -d "$1" ] && [[ ":$PATH:" != *":$1:"* ]]; then
        export PATH="$1:$PATH"
    fi
}
# User-specific bin directory
path_add "$HOME/bin"

# Dotfiles binaries (highest priority)
path_add "$DOTFILES/bin"

# Local project binaries (second highest priority)
path_add "node_modules/.bin"
path_add "vendor/bin"

# Homebrew binaries
path_add "/opt/homebrew/bin"
path_add "/opt/homebrew/sbin"

# Development tools
path_add "$HOME/.composer/vendor/bin"  # Composer global packages
path_add "$HOME/.node/bin"             # Node global binaries
path_add "$HOME/.yarn/bin"             # Yarn global binaries

# Language specific tools
path_add "/opt/homebrew/opt/openjdk/bin"    # Java
path_add "/opt/homebrew/opt/php/bin"        # PHP binaries
path_add "/opt/homebrew/opt/php/sbin"       # PHP system binaries
path_add "/usr/local/opt/openjdk/bin"       # Java (fallback location)

# Framework specific
path_add "$HOME/flutter/bin"               # Flutter SDK
path_add "$HOME/go/bin"                    # Go binaries
path_add "$HOME/.cargo/bin"                # Rust binaries

# Python tools (if using system Python)
path_add "$HOME/.local/bin"

# macOS specific
path_add "/usr/local/bin"
path_add "/usr/local/sbin"

# Optional: GNU coreutils (uncomment if needed)
# Note: This can cause compatibility issues with some scripts
# path_add "$(brew --prefix coreutils)/libexec/gnubin"

# Clean up function
unset -f path_add

# Export final PATH
export PATH
