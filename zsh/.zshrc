# Oh My Zsh
export ZSH="$HOME/dotfiles/zsh/oh-my-zsh"
ZSH_THEME=""
plugins=(git kubectl)
source "$ZSH/oh-my-zsh.sh"

# Environment
export XDG_CONFIG_HOME="$HOME/.config"
export EDITOR="nvim"
export VISUAL="nvim"
export CLICOLOR=1
export GPG_TTY=$(tty)
export LC_ALL=en_US.UTF-8
export LANG="$LC_ALL"
export APPLE_SSH_ADD_BEHAVIOR=macos
export HOMEBREW_NO_ENV_HINTS=1
export MANPAGER="less -R --use-color -Dd+r -Du+b"
export FZF_DEFAULT_COMMAND='rg --files --hidden --glob "!.git"'
export OPENCODE_DISABLE_CLAUDE_CODE_SKILLS=1

export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOPRIVATE=github.com/tickup-se

export NVM_DIR="$HOME/.nvm"

# PATH
eval "$(/opt/homebrew/bin/brew shellenv)"
export PATH="$(brew --prefix rustup)/bin:$PATH"
export PATH="$HOME/.local/bin:$GOBIN:$PATH"

# Tool integrations
eval "$(zoxide init zsh)"
source <(fzf --zsh)

# NVM: add default node to PATH eagerly, lazy-load nvm itself
_nvm_node_bin="$(ls -d "$NVM_DIR/versions/node/"*/bin 2>/dev/null | tail -1)"
[ -d "$_nvm_node_bin" ] && PATH="$_nvm_node_bin:$PATH"
unset _nvm_node_bin

nvm() {
  unfunction nvm 2>/dev/null
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  nvm "$@"
}

# Plugins
ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"
source "$HOME/dotfiles/zsh/plugins/fzf-tab/fzf-tab.plugin.zsh"
source "$HOME/dotfiles/zsh/plugins/fast-syntax-highlighting/fast-syntax-highlighting.plugin.zsh"
source "$HOME/dotfiles/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh"
source "$HOME/dotfiles/zsh/plugins/zsh-vim-mode/zsh-vim-mode.plugin.zsh"

# Completion
zstyle ":completion:*" special-dirs false
setopt globdots

# Aliases
alias reloadzsh=". ~/.zshrc && echo 'ZSH config reloaded from ~/.zshrc'"

# Docker
alias d="docker"
alias dc="docker compose"
alias deit="docker exec -it"

# Kubernetes
# The global kubeconfig has no current context on purpose, so nothing is
# targeted until you pick one. kctx pins a context to the current shell only;
# kctx - drops it again.
function kctx() {
  if [[ "$1" == "-" ]]; then
    _kctx_cleanup
    unset KUBECONFIG
    echo "kube context: $(command kubectl config current-context 2>/dev/null || echo none)"
    return
  fi
  local ctx="$1"
  if [[ -z "$ctx" ]]; then
    ctx="$(KUBECONFIG="$HOME/.kube/config" command kubectl config get-contexts -o name | fzf --prompt="kube context> ")" || return 1
  fi
  local shell_config="${TMPDIR:-/tmp}/kubeconfig-$$.yaml"
  (umask 077 && KUBECONFIG="$HOME/.kube/config" command kubectl config view --minify --flatten --context "$ctx" >"$shell_config") || return 1
  export KUBECONFIG="$shell_config"
  echo "kube context: $ctx (this shell only)"
}
function _kctx_cleanup() {
  rm -f "${TMPDIR:-/tmp}/kubeconfig-$$.yaml"
}
autoload -Uz add-zsh-hook
add-zsh-hook zshexit _kctx_cleanup
function _kctx() {
  compadd -- - $(KUBECONFIG="$HOME/.kube/config" command kubectl config get-contexts -o name 2>/dev/null)
}
compdef _kctx kctx
command -v kubecolor >/dev/null 2>&1 && alias kubectl="kubecolor"
command -v kubecolor >/dev/null 2>&1 && alias k="kubecolor"
alias kssd=kubectl-show-secret-data

# Editor
alias vi="nvim"

# git
alias gdd="git diff --no-ext-diff"
alias gdds="git diff --no-ext-diff --staged"

# Files
alias ls="ls -A"
alias ll="ls -lAh"
alias la="ls -lah"

# General
alias s="sudo"

# Go
alias gotest="go test ./... -coverprofile=coverage.out -covermode=atomic"
alias gotchtml="go tool cover -html=coverage.out -o coverage.html && open coverage.html"
alias gotcfn="go tool cover -func coverage.out"
alias gotc="go tool cover -html=coverage/coverage.txt"

# Python
alias psv="source .venv/bin/activate"

# Sesame
alias so="sesame open"
alias sopl="sesame open plutus"
alias sohe="sesame open hermes"
alias sobetl="sesame open bahnhof-etl"
alias sobres="sesame open bahnhof-research"
alias sosa="sesame open sesame"

# dbt
alias dbtf="$HOME/.local/bin/dbt"

# opencode
alias oc="opencode"

# Functions

# kubectl secrets helper
function kubectl-show-secret-data() {
  for field in $(kubectl get secret "$@" -o json | jq -r '.data | keys[]') ; do
    echo -n "${field}: "
    kubectl get secret "$@" -o=jsonpath="{.data.${field}}" | base64 --decode
    echo ""
  done
}

function list-oci-helm-chart() {
  skopeo list-tags $(echo "$1" | sed -e 's|oci://|docker://|') | \
    jq -r '.Tags[]' | sort -V
}

# Secrets from macOS Keychain
export GITHUB_TOKEN_MCP=$(security find-generic-password -a "$USER" -s "GITHUB_TOKEN_MCP" -w)
export CONTEXT7_API_KEY="$(security find-generic-password -a "$USER" -s context7-api-key -w 2>/dev/null)"

# Prompt
eval "$(starship init zsh)"

# bun completions
[ -s "/Users/hugo/.bun/_bun" ] && source "/Users/hugo/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
