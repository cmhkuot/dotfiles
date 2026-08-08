#!/usr/bin/env zsh
#
# Completion system optimization
#
# On slow systems, checking the cached .zcompdump file to see if it must be
# regenerated adds a noticeable delay to zsh startup. This optimization restricts
# the check to once a day, significantly improving startup performance.
#
# The globbing explanation:
# - '#q' is an explicit glob qualifier that makes globbing work within zsh's [[ ]] construct
# - 'N' makes the glob pattern evaluate to nothing when it doesn't match (rather than throw a globbing error)
# - '.' matches "regular files"
# - 'mh+24' matches files (or directories) that are older than 24 hours

# Note: compinit is initialized by Oh My Zsh in this setup.
# This file only applies completion styles/options.

# Additional completion optimizations
zstyle ':completion:*' use-cache on
zstyle ':completion:*' cache-path ~/.zsh/cache

# Make completion case-insensitive and partial-word completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*' 'l:|=* r:|=*'

# Colorize completions using default `ls` colors
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# Speed up completion by avoiding partial globs
zstyle ':completion:*' accept-exact '*(N)'
