# ============================================================================
# Git Aliases (the essential ones from oh-my-zsh)
# ============================================================================

alias g='git'
alias ga='git add'
alias gaa='git add --all'
alias gb='git branch'
alias gba='git branch -a'
alias gbd='git branch -d'
alias gc='git commit'
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
alias ggpull='git pull origin $(git branch --show-current)'
alias ggpush='git push origin $(git branch --show-current)'

# Custom git branch viewer (from your old config)
alias rb='git for-each-ref --count=20 --sort=-committerdate refs/heads/ --format='\''%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'\'
alias gcm='git checkout master'

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

# Better ls with eza (modern ls replacement)
if command -v eza &> /dev/null; then
  alias ls='eza --icons --git'
  alias ll='eza --icons --git -lah'
  alias la='eza --icons --git -a'
  alias l='eza --icons --git'
  alias lt='eza --icons --git --tree --level=2'
else
  # Fallback to regular ls if eza not installed
  alias ls='ls -GA'
  alias ll='ls -lah'
  alias la='ls -A'
  alias l='ls -ACF'
fi

# Better cat with bat
if command -v bat &> /dev/null; then
  alias cat='bat --style=auto'
  alias catt='/bin/cat'  # Use original cat if needed
fi

# Quick navigation
alias -- -='cd -'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'

# Safe operations
alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Docker
alias dc='docker-compose'

# Misc
alias c='clear'
alias h='history'
alias zshconfig='$EDITOR ~/.zshrc'
alias reload='source ~/.zshrc'

# ============================================================================
# Release Management
# ============================================================================

# Retag a release with confirmation
# Usage: retag 6.3.64
retag() {
  local tag="$1"

  if [[ -z "$tag" ]]; then
    echo "Usage: retag <tag>"
    echo "Example: retag 6.3.64"
    return 1
  fi

  # Check if we're in a git repo
  if ! git rev-parse --is-inside-work-tree &>/dev/null; then
    echo "Error: Not in a git repository"
    return 1
  fi

  # Get repo name from remote
  local repo=$(basename -s .git $(git remote get-url origin 2>/dev/null) 2>/dev/null || basename $(pwd))

  # Check if tag exists
  if ! git rev-parse "$tag" &>/dev/null; then
    echo "Error: Tag '$tag' does not exist"
    return 1
  fi

  echo ""
  echo "=== Retag Summary ==="
  echo "Repository: \033[1;33m$repo\033[0m"
  echo "Tag:        \033[1;33m$tag\033[0m"
  echo "Current:    $(git rev-parse --short $tag) -> New: $(git rev-parse --short HEAD)"
  echo ""
  echo "=== Changes since tag ==="
  git diff --stat "$tag"..HEAD
  echo ""

  # Confirm
  echo -n "Proceed with force re-tagging? [y/N] "
  read confirm

  if [[ "$confirm" =~ ^[Yy]$ ]]; then
    echo ""
    echo "Deleting remote tag..."
    git push origin :"$tag"

    echo "Creating new tag..."
    git tag -f "$tag"

    echo "Pushing tag..."
    git push --tags -f

    echo ""
    echo "Done! Tag '$tag' has been updated."
  else
    echo "Aborted."
    return 1
  fi
}
