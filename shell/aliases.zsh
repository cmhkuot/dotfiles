# Aliases for macOS zsh
# Clean, deduplicated, and organized

# -------------------------------------------------
# Shortcuts
# -------------------------------------------------
alias o="open ."
alias reload_shell="omz reload" # Reload Zsh configuration

# -------------------------------------------------
# Homebrew
# -------------------------------------------------
# To fix brew doctor's warning: "config scripts exist outside your system or Homebrew directories"
# alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew'
alias brew_backup="brew bundle dump -f"
alias brew_cleanup="brew cleanup --prune=30"

# -------------------------------------------------
# Python (via pyenv)
# -------------------------------------------------
alias python="$(pyenv which python)"
alias pip="$(pyenv which pip)"

# -------------------------------------------------
# System utilities
# -------------------------------------------------
alias gatekeeper="$DOTFILES/bin/gatekeeper.sh" # Gatekeeper helper
alias ssh_config="code ~/.ssh/config"
alias hostfile="sudo vi /etc/hosts"

# -------------------------------------------------
# File listing (eza)
# -------------------------------------------------
# * lists everything with directories first
alias ll="eza -al --group-directories-first"
# * lists only directories (no files)
alias ld="eza -lD"
# * lists only files (no directories)
alias lf="eza -lF --color=always | grep -v /"
# * lists only hidden files (no directories)
alias lh="eza -dl .* --group-directories-first"
# * lists only files sorted by size
alias ls="eza -alF --color=always --sort=size | grep -v /"
# * lists everything sorted by time updated
alias lt="eza -al --sort=modified"
# Better tree view
alias tree='eza --tree --level=3'
alias treel='eza --tree --level=2 -l'

# -------------------------------------------------
# Directories
# -------------------------------------------------
alias dotfiles="cd $DOTFILES"
alias projects="cd $HOME/Code"
alias library="cd $HOME/Library"

# -------------------------------------------------
# Network
# -------------------------------------------------
alias ip="curl ipconfig.pw/json"
alias local_ip="ifconfig -a | grep -o 'inet\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet? (addr:)? ?/, ""); print }'"
alias speedtest='curl -s https://raw.githubusercontent.com/sivel/speedtest-cli/master/speedtest.py | python3 -'

# -------------------------------------------------
# Development helpers
# -------------------------------------------------
alias npm_fresh="rm -rf node_modules/ package-lock.json && npm install"
alias yarn_fresh="rm -rf node_modules/ package-lock.json yarn.lock && yarn install"
alias url_encode='python3 -c "import sys, urllib.parse as ul; print(ul.quote_plus(sys.argv[1]))"'
alias url_decode='python3 -c "import sys, urllib.parse as ul; print(ul.unquote_plus(sys.argv[1]))"'

# -------------------------------------------------
# Docker shortcuts
# -------------------------------------------------
# alias dps='docker ps'
# alias dimg='docker images'
# alias dexec='docker exec -it'
# alias dlog='docker logs -f'
# alias dclean='docker system prune -af'

# -------------------------------------------------
# System monitoring
# -------------------------------------------------
alias meminfo='top -l 1 -s 0 | grep PhysMem'
alias psmem='ps auxf | sort -nr -k 4 | head -10'
alias pscpu='ps auxf | sort -nr -k 3 | head -10'
alias cpu='top -l 2 -s 0 | grep "CPU usage"'
alias shtop='sudo htop' # run htop with root rights

# -------------------------------------------------
# System maintenance
# -------------------------------------------------
alias cleanup='brew cleanup --prune=30 && brew autoremove && npm cache clean --force && yarn cache clean'
# Lock the screen
alias afk="osascript -e 'tell application \"System Events\" to keystroke \"q\" using {command down,control down}'"
# Empty the Trash on the main HDD. Also, clear Apple's System Logs to improve shell startup speed
alias empty_trash="sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"
# Flush Directory Service cache
alias flush_dns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# -------------------------------------------------
# Better defaults
# -------------------------------------------------
alias cp='cp -i'
alias mv='mv -i'
alias rm='rm -i'

# -------------------------------------------------
# Quick navigation
# -------------------------------------------------
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias .....='cd ../../../..'
