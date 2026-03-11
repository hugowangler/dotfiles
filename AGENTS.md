# AGENTS.md

Personal dotfiles repository for macOS. Configures zsh, neovim, tmux, git, and
IdeaVim. Deployed to `$HOME` using GNU Stow. No application code, no build
system, no tests.

## Repository structure

```
dotfiles/
  archive/      # old config kept for reference (not deployed)
  git/          # git config      -> stow target: ~/.config/git/config
  idea/         # IdeaVim config  -> stow target: ~/.ideavimrc (unused, kept for reference)
  nvim/         # neovim config   -> stow target: ~/.config/nvim/
  tmux/         # tmux config     -> stow target: ~/.tmux.conf
  zsh/          # zsh config      -> stow target: ~/.zshrc
    oh-my-zsh/          # [submodule] ohmyzsh/ohmyzsh
    plugins/
      fast-syntax-highlighting/  # [submodule] zdharma-continuum/fast-syntax-highlighting
      fzf-tab/                   # [submodule] Aloxaf/fzf-tab
      zsh-autosuggestions/       # [submodule] zsh-users/zsh-autosuggestions
      zsh-vim-mode/              # [submodule] softmoth/zsh-vim-mode
```

Each top-level directory is a Stow package. The internal paths mirror the
target layout relative to `$HOME`. For example `git/.config/git/config` gets
symlinked to `~/.config/git/config`.

## Commands

There is no build, lint, or test pipeline for this repo.

### Deployment (GNU Stow)

```sh
# Deploy a single package (e.g. zsh)
stow -d ~/dotfiles -t ~ zsh

# Deploy all packages
stow -d ~/dotfiles -t ~ git idea nvim tmux zsh

# Dry-run to preview what would be symlinked
stow -d ~/dotfiles -t ~ -n -v zsh
```

### Git submodules

```sh
# Clone with submodules
git clone --recurse-submodules <url>

# Update all submodules to latest upstream
git submodule update --remote --merge
```

### Neovim plugins (vim-plug)

Plugins are managed by vim-plug in `nvim/.config/nvim/init.vim`.

```sh
# Install plugins
nvim +PlugInstall +qall

# Update plugins
nvim +PlugUpdate +qall
```

### Reload configs without restarting

- **zsh**: `source ~/.zshrc` (or alias `reloadzsh`)
- **tmux**: `<prefix> r` (bound in .tmux.conf) or `tmux source-file ~/.tmux.conf`
- **nvim**: `:source $MYVIMRC` (or `<leader>sv`)

## Git submodules -- do not edit

The directories marked `[submodule]` above are external repos. Never modify
files inside them. If a plugin needs configuration, do it in the parent config
file (e.g. plugin settings go in `zsh/.zshrc`, not inside `zsh/plugins/*/`).

## Commit conventions

This repo uses conventional commit prefixes with **lowercase** messages:

```
feat: add fzf-tab plugin
fix: correct tmux pane splitting on mac
chore: update submodules
```

Prefixes: `feat`, `fix`, `chore`, `docs`, `refactor`. Keep messages short
(under 72 characters). No scope parentheses are used.

## Code style

### Shell (zsh)

- Use `# Section name` for section headers -- single-line comments, no
  decorative separators or banner-style comment blocks.
- Group related aliases under a sub-comment (e.g. `# Docker`, `# Kubernetes`).
- Double-quote variables and strings: `"$HOME/path"`, `"$ZSH"`.
- Use `$HOME` instead of `~` in exports and variable assignments.
- 2-space indentation inside functions and control structures.
- Functions use the `function name() { }` form.
- Use `command -v` for command existence checks, not `which`.
- Keep `.stow-local-ignore` updated if adding directories that should not
  be symlinked (e.g. `zsh/plugins` is ignored since plugins are sourced by
  absolute path from the dotfiles directory).

### Vim / Neovim

- `init.vim` is the entry point; additional config goes in `plugin/*.vim`.
- 4-space indentation (`tabstop=4`, `shiftwidth=4`, `expandtab`).
- Leader key is `<Space>`.
- Plugin declarations go inside the `plug#begin` / `plug#end` block in
  `init.vim`. Plugin-specific settings go in `plugin/<name>.vim`.
- Lua blocks are inlined via `lua << EOF ... EOF` in vimscript files.

### Tmux

- Prefix is `C-a` (not the default `C-b`).
- Vim-tmux-navigator integration is configured -- pane switching uses
  `C-h/j/k/l` and is shared between tmux and neovim.
- vi mode is enabled for copy mode (`mode-keys vi`).

### Git config

- GPG signing is enabled for commits (`commit.gpgsign = true`).
- SSH is used for all GitHub URLs (`url.ssh://git@github.com/.insteadOf`).
- Fast-forward only pulls (`pull.ff = only`).
- Difftastic is the default diff viewer (`diff.external = difft`).
  `git diff` and oh-my-zsh aliases (`gd`, `gds`) all use difftastic.
  Use shell alias `gdd` for standard patch-format diff output.

## Things to avoid

- **No secrets or keys.** The git config contains a public signing key ID,
  which is fine. Never add private keys, tokens, or credentials.
- **No hardcoded absolute paths.** Always use `$HOME`, `$GOPATH`, etc.
  The one exception is `/opt/homebrew/bin/brew` which is the standard
  macOS ARM Homebrew path.
- **No modifications to submodule contents.** Configure plugins externally.
- **No generated or cache files.** The `.gitignore` excludes `.DS_Store`,
  `.mypy_cache`, and `.netrwhist`. Add similar patterns for any new tools.
- **No package manager lock files.** This repo has no `package.json`,
  `requirements.txt`, or similar. It manages only config files.

## Environment context

Target platform is macOS (Apple Silicon). The typical terminal setup is
iTerm2 running tmux sessions with zsh as the shell (Pure prompt).

- Homebrew at `/opt/homebrew`
- Tools assumed installed: `fzf`, `rg` (ripgrep), `zoxide`, `jq`, `difft`,
  `go`, `nvm`/`node`, `kubectl`, `docker`, `stow`
