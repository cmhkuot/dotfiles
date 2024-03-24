# Load dotfiles binaries
export PATH="$DOTFILES/bin:$PATH"

# Load Composer tools
export PATH="$HOME/.composer/vendor/bin:$PATH"

# Load Node global installed binaries
export PATH="$HOME/.node/bin:$PATH"

# Use project specific binaries before global ones
export PATH="node_modules/.bin:vendor/bin:$PATH"

export PATH="/opt/homebrew/bin:$PATH"
export PATH="/opt/homebrew/sbin:$PATH"

export PATH="$HOME/.yarn/bin:$PATH"

export PATH="/opt/homebrew/opt/openjdk/bin:$PATH"

# flutter
export PATH=$HOME/flutter/bin:$PATH

# Load PHP
export PATH="/opt/homebrew/opt/php/bin:$PATH"
export PATH="/opt/homebrew/opt/php/sbin:$PATH"

# Make sure coreutils are loaded before system commands
# I've disabled this for now because I only use "ls" which is
# referenced in my aliases.zsh file directly.
#export PATH="$(brew --prefix coreutils)/libexec/gnubin:$PATH"
