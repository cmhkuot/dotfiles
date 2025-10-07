

# Path to your dotfiles
export DOTFILES=$HOME/.dotfiles

# Oh My Zsh
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="ultima"

# Performance optimizations
ZSH_DISABLE_COMPFIX=true

# ZSH-NVM settings
export NVM_COMPLETION=true
export NVM_AUTO_USE=true

# Oh My Zsh update settings
zstyle ':omz:update' mode auto
zstyle ':omz:update' frequency 7

# Cache & compdump
ZSH_CACHE_DIR=${ZSH_CACHE_DIR:-$HOME/.oh-my-zsh/cache}
mkdir -p "$ZSH_CACHE_DIR" 2>/dev/null || true
ZSH_COMPDUMP="$ZSH_CACHE_DIR/.zcompdump"

# History settings
HIST_STAMPS="dd/mm/yyyy"
export HISTSIZE=50000
export SAVEHIST=50000
export HISTFILE="$HOME/.zsh_history"
export HISTCONTROL=ignoredups
setopt HIST_EXPIRE_DUPS_FIRST HIST_IGNORE_DUPS HIST_IGNORE_ALL_DUPS HIST_FIND_NO_DUPS HIST_IGNORE_SPACE HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS HIST_VERIFY SHARE_HISTORY
export HISTIGNORE="ls:cd:cd -:pwd:exit:date:* --help:history:clear"
export HISTORY_IGNORE="(ls|cd|cd -|pwd|exit|date|* --help|history|clear)"

# Locale
export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8

# Homebrew Bundle
export HOMEBREW_BUNDLE_FILE="$DOTFILES/macos/Brewfile"
export HOMEBREW_BUNDLE_FILE_GLOBAL="$DOTFILES/macos/Brewfile"
export HOMEBREW_BUNDLE_DUMP_DESCRIBE=true
export HOMEBREW_BUNDLE_DUMP_NO_VSCODE=false

# ZSH custom folder
ZSH_CUSTOM=$DOTFILES/shell

# Plugins
plugins=(
	git
	brew
	zsh-nvm
	aliases
	zsh-autosuggestions
	yarn-autocompletions
	zsh-syntax-highlighting
)

source $ZSH/oh-my-zsh.sh

# Load custom scripts
[ -f $ZSH_CUSTOM/performance.zsh ] && source $ZSH_CUSTOM/performance.zsh
[ -f $ZSH_CUSTOM/path.zsh ] && source $ZSH_CUSTOM/path.zsh
[ -f $ZSH_CUSTOM/.functions ] && source $ZSH_CUSTOM/.functions
[ -f $ZSH_CUSTOM/aliases.zsh ] && source $ZSH_CUSTOM/aliases.zsh
[ -f $ZSH_CUSTOM/compinit.zsh ] && source $ZSH_CUSTOM/compinit.zsh

# SSH keychain
ssh-add -A 2>/dev/null

# ZSH Autosuggestions
export ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
ZSH_AUTOSUGGEST_CLEAR_WIDGETS+=(bracketed-paste up-line-or-search down-line-or-search expand-or-complete accept-line push-line-or-edit)
ZSH_AUTOSUGGEST_HISTORY_IGNORE="(cd *|curl *)"

# pyenv
export PYENV_ROOT="$HOME/.pyenv"
[[ -d $PYENV_ROOT/bin ]] && export PATH="$PYENV_ROOT/bin:$PATH"
eval "$(pyenv init - zsh)"

# Node/NVM
export NVM_SYMLINK_CURRENT=true
export NODE_OPTIONS="--no-deprecation"
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# Ghostty integration
if [[ -n $GHOSTTY_RESOURCES_DIR ]]; then
	source "$GHOSTTY_RESOURCES_DIR"/shell-integration/zsh/ghostty-integration
fi

# Compilation flags
export CPPFLAGS="-I/opt/homebrew/opt/openjdk/include"
