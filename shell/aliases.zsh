# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

# Shortcuts
alias o="open ."
alias zshedit="code ~/.dotfiles/shell/.zshrc"
alias reloadshell="omz reload"
alias reloaddns="dscacheutil -flushcache && sudo killall -HUP mDNSResponder"
# alias brew='env PATH="${PATH//$(pyenv root)\/shims:/}" brew' #To fix brew doctor's warning ""config" scripts exist outside your system or Homebrew directories"
alias brewbackup="brew bundle dump -f"
alias brewcleanup="brew cleanup --prune=30"
alias python="$(pyenv which python)"
alias pip="$(pyenv which pip)"

# alias cleanmymac="$DOTFILES/bin/cleanup.sh" # Cleanup caches and temporary files of Mac
alias gatekeeper="$DOTFILES/bin/gatekeeper.sh" # Gatekeeper hepler

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

# alias shrug="echo '¯\_(ツ)_/¯' | pbcopy"
# alias compile="commit 'compile'"
# alias version="commit 'version'"
alias sshconfig="code ~/.ssh/config"
alias hostfile="sudo vi /etc/hosts"

# Directories
alias dotfiles="cd $DOTFILES"
alias projects="cd $HOME/Code"
alias library="cd $HOME/Library"

# IP addresses
alias ip="curl ipconfig.pw/json"
alias localip="ifconfig -a | grep -o 'inet\? \(addr:\)\?\s\?\(\(\([0-9]\+\.\)\{3\}[0-9]\+\)\|[a-fA-F0-9:]\+\)' | awk '{ sub(/inet? (addr:)? ?/, \"\"); print }'"

# Laravel
# alias a="php artisan"
# alias fresh="php artisan migrate:fresh --seed"
# alias tinker="php artisan tinker"
# alias seed="php artisan db:seed"
# alias serve="php artisan serve"

# PHP
# alias cfresh="rm -rf vendor/ composer.lock && composer i"

# JS
alias nfresh="rm -rf node_modules/ package-lock.json && npm install"
alias yfresh="rm -rf node_modules/ package-lock.json yarn.lock && yarn install"
# alias watch="npm run watch"

# Docker
# alias docker-composer="docker-compose"

# Git
alias gst="git status"
alias gb="git branch"
alias gc="git checkout"
alias gl="git log --oneline --decorate --color"
alias amend="git add . && git commit --amend --no-edit"
alias commit="git add . && git commit -m"
alias diff="git diff"
alias force="git push --force"
alias nuke="git clean -df && git reset --hard"
alias pop="git stash pop"
alias pull="git pull"
alias push="git push"
alias resolve="git add . && git commit --no-edit"
alias stash="git stash -u"
alias unstage="git restore --staged ."
alias wip="commit wip"

# Flush Directory Service cache
alias flushdns="sudo dscacheutil -flushcache; sudo killall -HUP mDNSResponder"

# Redis
# alias flush-redis="redis-cli FLUSHALL"

# Lock the screen
alias afk="osascript -e 'tell application \"System Events\" to keystroke \"q\" using {command down,control down}'"

# Empty the Trash on all mounted volumes and the main HDD
# Also, clear Apple’s System Logs to improve shell startup speed
alias emptytrash="sudo rm -rfv /Volumes/*/.Trashes; sudo rm -rfv ~/.Trash; sudo rm -rfv /private/var/log/asl/*.asl"

# run `htop` with root rights
alias shtop='sudo htop'
