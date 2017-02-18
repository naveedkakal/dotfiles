# Sets up rbenv shims
if (( $+commands[rbenv] ))
then
  eval "$(rbenv init - zsh --no-rehash)"
fi

# Useful aliases
alias rb='git for-each-ref --count=25 --sort=-committerdate refs/heads/ --format='\''%(HEAD) %(color:yellow)%(refname:short)%(color:reset) - %(color:red)%(objectname:short)%(color:reset) - %(contents:subject) - %(authorname) (%(color:green)%(committerdate:relative)%(color:reset))'\'
alias be="bundle exec"
alias ber="bundle exec rspec"

# Sets the editor as sublime text
export EDITOR='vim'


