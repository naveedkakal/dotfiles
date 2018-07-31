# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
HYPHEN_INSENSITIVE="true"

# Uncomment the following line to display red dots whilst waiting for completion.
COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
# DISABLE_UNTRACKED_FILES_DIRTY="true"

# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=$HOME/.dotfiles/oh-my-zsh

# oh my zsh will auto update without prompt.
DISABLE_UPDATE_PROMPT=true

# Theme related configuration
ZSH_THEME="bullet-train"

BULLETTRAIN_CONTEXT_DEFAULT_USER='naveed'
BULLETTRAIN_PROMPT_ORDER=(
  time
	status
	# custom
	# context
	dir
	# perl
	# ruby
	# virtualenv
	# go
	git
	# hg
	cmd_exec_time
)

BULLETTRAIN_PROMPT_CHAR='$ '
