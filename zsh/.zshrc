# Path to your oh-my-zsh installation.
export ZSH=$HOME/dotfiles/zsh/oh-my-zsh

# include z
. ~/dotfiles/z/z.sh

# aliases
alias reloadzsh=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"
alias d="docker"
command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"
command -v kubecolor >/dev/null 2>&1 && alias k="kubecolor"
alias dc="docker compose"
alias s="sudo"
alias deit="docker exec -it"
alias vi="nvim"
alias fbc="black . --check -l 80"
alias fb="black . -l 80"
alias gotest="go test ./... -coverprofile=coverage.out -covermode=atomic"
alias gotchtml="go tool cover -html=coverage.out -o coverage.html && open coverage.html"
alias gotcfn="go tool cover -func coverage.out"
alias gotc="go tool cover -html=coverage/coverage.txt"
alias pm="python main.py"
alias psv="source .venv/bin/activate"
alias pssv="source server/venv/bin/activate"
alias mt="make test"
alias mtc="make test-coverage"
alias presetdb="go run github.com/prisma/prisma-client-go migrate reset --force --preview-feature && go run github.com/prisma/prisma-client-go migrate deploy --preview-feature"
alias bi="go run cmd/import/main.go"
alias bsi="go run cmd/export/main.go"
alias gmi="go run cmd/migrate/main.go"
alias gmirb="go run cmd/migrate/main.go --rollback"
alias gogql="go run github.com/99designs/gqlgen generate --verbose"

alias so="sesame open"
alias sopl="sesame open plutus"
alias sohe="sesame open hermes"
alias sobetl="sesame open bahnhof-etl"
alias sobres="sesame open bahnhof-research"
alias sosa="sesame open sesame"

# Add wisely, as too many plugins slow down shell startup.
plugins=(git z kubectl)

ZSH_THEME=""

source $ZSH/oh-my-zsh.sh

ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

# dont show ".." and "." in auto-completions
zstyle ":completion:*" special-dirs false

# show hidden files in completions
setopt globdots

source $HOME/dotfiles/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh
source $HOME/dotfiles/zsh/plugins/zsh-vim-mode/zsh-vim-mode.plugin.zsh

# NVM lazy-loader: defers ~300ms startup cost until first use
export NVM_DIR="$HOME/.nvm"
_nvm_lazy_load() {
  unfunction nvm node npm npx 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
}
nvm()  { _nvm_lazy_load; nvm "$@"; }
node() { _nvm_lazy_load; node "$@"; }
npm()  { _nvm_lazy_load; npm "$@"; }
npx()  { _nvm_lazy_load; npx "$@"; }

export GPG_TTY=$(tty)

export GO111MODULE=on  # Enable module mode
export GOROOT=/usr/local/go
export GOPATH=$HOME/go
export GOBIN=$GOPATH/bin
export PATH=$PATH:$GOROOT:$GOPATH:$GOBIN
export GOPRIVATE=github.com/tickup-se
export PATH="/Users/hugo/.local/bin:$PATH"
eval "$(/opt/homebrew/bin/brew shellenv)"

# Fix to get rid of some locale issues in SSH
export LC_ALL=en_US.UTF-8
export LANG=${LC_ALL}

# kubcetl secrets helper
function kubectl-show-secret-data() {
  for field in $(kubectl get secret "$@" -o json | jq -r '.data | keys[]') ; do
    echo -n "${field}: "
    kubectl get secret "$@" -o=jsonpath="{.data.${field}}" | base64 --decode
    echo ""
  done
}
alias kssd=kubectl-show-secret-data

function list-oci-helm-chart() {
  skopeo list-tags $(echo $1 | sed -e 's|oci://|docker://|') | \
    jq -r '.Tags[]' | sort -V
}

# fix ssh-add -A for macos
export APPLE_SSH_ADD_BEHAVIOR=macos
export PATH="/opt/homebrew/opt/libpq/bin:$PATH"

# Kubernetes config (added by kubeconfig installer)
export KUBECONFIG=/Users/hugo/.kube/config
# Added by dbt Fusion extension
alias dbtf=/Users/hugo/.local/bin/dbt

export MANPAGER="less -R --use-color -Dd+r -Du+b"

autoload -U promptinit; promptinit
prompt pure
