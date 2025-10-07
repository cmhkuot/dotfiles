#!/usr/bin/env zsh
#
# Performance optimizations for Zsh
#

# Zsh options for better performance
setopt NO_BEEP                    # Don't beep on errors
setopt AUTO_CD                    # Change directory without typing cd
setopt CDABLE_VARS               # Change directory to a path stored in a variable
setopt CORRECT                   # Try to correct the spelling of commands
setopt CORRECT_ALL               # Try to correct the spelling of all arguments
setopt AUTO_LIST                 # Automatically list choices on ambiguous completion
setopt AUTO_MENU                 # Show completion menu on successive tab press
setopt AUTO_PUSHD                # Push directories onto stack automatically
setopt PUSHD_IGNORE_DUPS         # Don't push duplicate directories
setopt PUSHD_MINUS               # Use - instead of + for pushd
setopt EXTENDED_GLOB             # Enable extended globbing
setopt GLOB_DOTS                 # Include hidden files in glob patterns
setopt NUMERIC_GLOB_SORT         # Sort filenames numerically when it makes sense

# History options (performance related)
setopt APPEND_HISTORY            # Append history instead of overwriting
setopt INC_APPEND_HISTORY        # Write to history file immediately
setopt HIST_FIND_NO_DUPS         # Don't show duplicates when searching
setopt HIST_IGNORE_SPACE         # Don't save commands that start with space
setopt HIST_NO_STORE             # Don't store history commands in history
setopt HIST_REDUCE_BLANKS        # Remove extra blanks from history
setopt HIST_SAVE_BY_COPY         # Save history by copying (safer)

# Completion performance optimizations
setopt HASH_LIST_ALL             # Hash entire command path first time
setopt COMPLETE_IN_WORD          # Allow completion in middle of word
setopt ALWAYS_TO_END             # Move cursor to end after completion
setopt PATH_DIRS                 # Perform path search even on command names with slashes
setopt AUTO_PARAM_SLASH          # Add trailing slash to directory names
setopt AUTO_PARAM_KEYS           # Remove trailing slash if next character is a word delimiter

# Job control optimizations
setopt AUTO_RESUME               # Commands without arguments resume suspended jobs
setopt LONG_LIST_JOBS            # List jobs in long format by default
setopt NOTIFY                    # Report status of background jobs immediately

# Disable resource-intensive features if not needed
unsetopt FLOW_CONTROL            # Disable start/stop characters in shell editor
unsetopt MENU_COMPLETE           # Don't autoselect the first completion entry
unsetopt AUTO_REMOVE_SLASH       # Don't remove trailing slash automatically

# Lazy loading functions for better startup performance
autoload -Uz add-zsh-hook
autoload -Uz vcs_info
autoload -Uz colors && colors
autoload -Uz compinit
autoload -Uz bashcompinit && bashcompinit

# Reduce escape sequence timeout
export KEYTIMEOUT=1

# Optimize word boundaries for better completion
export WORDCHARS='*?_-.[]~=&;!#$%^(){}<>'

# Cache directory for completions
[[ ! -d ~/.zsh/cache ]] && mkdir -p ~/.zsh/cache

# Performance monitoring (optional - comment out in production)
# zmodload zsh/zprof  # Uncomment to enable profiling
# To use: add 'zprof' at the end of .zshrc to see startup performance
