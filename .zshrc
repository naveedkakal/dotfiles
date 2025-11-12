# ============================================================================
# Zsh Configuration
# ============================================================================

# History configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_FIND_NO_DUPS
setopt HIST_REDUCE_BLANKS
setopt SHARE_HISTORY
setopt APPEND_HISTORY

# Directory navigation
setopt AUTO_CD
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

# Completion system
autoload -Uz compinit
compinit

# Case-insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'

# Better completion menu
zstyle ':completion:*' menu select
zstyle ':completion:*' list-colors ''

# ============================================================================
# Environment Variables
# ============================================================================

export EDITOR='vim'
export VISUAL='vim'

# Enable Elixir history
export ERL_AFLAGS="-kernel shell_history enabled"

# PATH additions
export PATH="/opt/homebrew/opt/mysql@8.4/bin:$PATH"
export PATH="/Users/naveedkakal/.codeium/windsurf/bin:$PATH"

# ============================================================================
# Tool Integrations
# ============================================================================

# fzf - fuzzy finder
[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# autojump - smart directory jumping
[ -f /opt/homebrew/etc/profile.d/autojump.sh ] && . /opt/homebrew/etc/profile.d/autojump.sh

# nvm - Node version manager
export NVM_DIR="$HOME/.nvm"
[ -s "/opt/homebrew/opt/nvm/nvm.sh" ] && . "/opt/homebrew/opt/nvm/nvm.sh"
[ -s "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm" ] && . "/opt/homebrew/opt/nvm/etc/bash_completion.d/nvm"

# rbenv - Ruby version manager
if command -v rbenv &> /dev/null; then
  eval "$(rbenv init -)"
fi

# asdf - version manager
if [ -f /opt/homebrew/opt/asdf/libexec/asdf.sh ]; then
  . /opt/homebrew/opt/asdf/libexec/asdf.sh
fi

# ============================================================================
# Aliases
# ============================================================================

# Source aliases from separate file
[ -f ~/.config/zsh/aliases.zsh ] && source ~/.config/zsh/aliases.zsh

# ============================================================================
# Zsh Plugins (for better autocomplete and syntax highlighting)
# ============================================================================

# zsh-autosuggestions - fish-like fast/unobtrusive autosuggestions
if [ -f ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh ]; then
  source ~/.config/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
  ZSH_AUTOSUGGEST_STRATEGY=(history completion)
  ZSH_AUTOSUGGEST_BUFFER_MAX_SIZE=20
fi

# zsh-syntax-highlighting - syntax highlighting as you type
# Note: This must be loaded AFTER all other plugins
if [ -f ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh ]; then
  source ~/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
fi

# ============================================================================
# Starship Prompt
# ============================================================================

# Initialize starship (must be at end of file)
if command -v starship &> /dev/null; then
  eval "$(starship init zsh)"
fi

# ============================================================================
# Local Configuration (NOT tracked in git - for secrets!)
# ============================================================================

# Source local config if it exists (for API keys, tokens, etc.)
[ -f ~/.zshrc.local ] && source ~/.zshrc.local
