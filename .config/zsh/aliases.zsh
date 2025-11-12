# ============================================================================
# Git Aliases (the essential ones from oh-my-zsh)
# ============================================================================

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gcmsg='git commit -m'
alias gco='git checkout'
alias gcb='git checkout -b'
alias gd='git diff'
alias gds='git diff --staged'
alias gf='git fetch'
alias gfa='git fetch --all'
alias gl='git pull'
alias gp='git push'
alias gpf='git push --force-with-lease'
alias gst='git status'
alias gsta='git stash'
alias gstp='git stash pop'
alias glog='git log --oneline --decorate --graph'
alias gloga='git log --oneline --decorate --graph --all'

# Custom git branch viewer (from your old config)
alias rb='git for-each-ref --count=20 --sort=-committerdate refs/heads/ --format='\''%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'\'

# ============================================================================
# Rails/Ruby Aliases
# ============================================================================

alias be="bundle exec"
alias ber="bundle exec rspec"
alias tdbr="RAILS_ENV=test bundle exec rake db:reset"
alias tmig="RAILS_ENV=test bundle exec rake db:migrate"

# ============================================================================
# Fun Aliases
# ============================================================================

alias realfeel="curl -s -N http://wttr.in/CHICAGO"

# ============================================================================
# General Aliases
# ============================================================================

# Better ls
alias ls='ls -G'
alias ll='ls -lah'
alias la='ls -A'
alias l='ls -CF'

# Quick navigation
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safe operations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Misc
alias c='clear'
alias h='history'
alias zshconfig='$EDITOR ~/.zshrc'
alias reload='source ~/.zshrc'
