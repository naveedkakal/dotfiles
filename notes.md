# Would you like to use another custom folder than $ZSH/custom?
ZSH_CUSTOM=~/.dotfiles/oh-my-zsh-custom

[ -f $HOME/.dotfiles/mytheme.zsh ] &&  source $HOME/.dotfiles/mytheme.zsh
source $ZSH/oh-my-zsh.sh
[ -f $HOME/.dotfiles/mydot.zsh ] &&  source $HOME/.dotfiles/mydot.zsh
