export PATH="$HOME/.cargo/bin:$HOME/.local/bin:$HOME/bin:$PATH"

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(git zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
