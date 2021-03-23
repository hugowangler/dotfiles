export PATH=$HOME/bin:/usr/local/bin:/usr/bin/site_perl/:/usr/bin/vendor_perl/:$PATH

# Path to your oh-my-zsh installation.
export ZSH=$HOME/dotfiles/zsh/oh-my-zsh

# include z
. ~/z.sh

# aliases
alias reloadzsh=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"
alias d="docker"
alias dc="docker-compose"
alias s="sudo"
alias dcopc="docker-compose -f docker-compose-check.yml up --build"
alias dcopd="docker-compose -f docker-compose-dev.yml up --build"
alias deit="docker exec -it"
alias vim="nvim"
alias vi="nvim"
alias fbc="black . --check -l 80"
alias fb="black . -l 80"
alias gotest="go test ./... -coverprofile=coverage.out"
alias gotchtml="go tool cover -html=coverage.out"
alias gotcfn="go tool cover -func coverage.out"
alias pm="python main.py"
alias psv "source venv/bin/activate"
alias pssv "source server/venv/bin/activate"

# Add wisely, as too many plugins slow down shell startup.
plugins=(git z)

ZSH_THEME="agnoster"

source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

prompt_context(){}

source $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/dotfiles/zsh/plugins/zsh-vim-mode/zsh-vim-mode.plugin.zsh

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/hugo/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/hugo/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/hugo/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/hugo/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
#
# Dont auto start conda
conda config --set auto_activate_base false

# pyenv path
export PYENV_ROOT="$HOME/.pyenv"
export PATH="$PYENV_ROOT/bin:$PATH"

if command -v pyenv 1>/dev/null 2>&1; then
  eval "$(pyenv init -)"
fi
source /usr/share/nvm/init-nvm.sh

export GPG_TTY=$(tty)

bindkey -v
source /opt/ros/noetic/setup.zsh
