# Path to your oh-my-zsh installation.
export ZSH=$HOME/dotfiles/zsh/oh-my-zsh

# include z
. ~/z.sh

# aliases
alias d="docker"
alias dc="docker-compose"
alias s="sudo"
alias dcopc="docker-compose -f docker-compose-check.yml up --build"
alias dcopd="docker-compose -f docker-compose-dev.yml up --build"
alias vim="nvim"
alias vi="nvim"

# Add wisely, as too many plugins slow down shell startup.
plugins=(git z)

ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

prompt_context(){}

source $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
