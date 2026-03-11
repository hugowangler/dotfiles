# AGENTS.md

Personal dotfiles repository for macOS. Configures zsh, neovim, tmux, git, and
IdeaVim. Deployed to `$HOME` using GNU Stow. No application code, no build
system, no tests.

## Repository structure

Each top-level directory is a Stow package. Internal paths mirror the target
layout relative to `$HOME` (e.g. `git/.config/git/config` -> `~/.config/git/config`).

| Package | Contents | Stow target |
|---------|----------|-------------|
| `git/` | git config | `~/.config/git/config` |
| `idea/` | IdeaVim config (unused, kept for reference) | `~/.ideavimrc` |
| `nvim/` | neovim config (Lua) | `~/.config/nvim/` |
| `tmux/` | tmux config | `~/.tmux.conf` |
| `zsh/` | zsh config + plugin submodules | `~/.zshrc` |
| `archive/` | old VimScript nvim config (not deployed) | -- |

**Neovim layout:** `init.lua` -> `config/lazy.lua` (bootstrap) -> `config/options.lua`,
`config/keymaps.lua`, `plugins/*.lua` (one file per plugin/group, auto-discovered).

**File search note:** `.fdignore` at repo root excludes `zsh/oh-my-zsh/` and
`zsh/plugins/` (submodule dirs) from `fd` searches. Agents using file search
tools should be aware these directories exist but are external code.

## Commands

There is no build, lint, or test pipeline for this repo.

### Deployment (GNU Stow)

```sh
stow -d ~/dotfiles -t ~ zsh            # deploy one package
stow -d ~/dotfiles -t ~ git idea nvim tmux zsh  # deploy all
stow -d ~/dotfiles -t ~ -n -v zsh      # dry-run
```

### Git submodules

All 5 submodules are under `zsh/` (oh-my-zsh + 4 plugins). Never modify files
inside submodule directories -- configure plugins in `.zshrc` instead.

```sh
git clone --recurse-submodules <url>
git submodule update --remote --merge   # update all to latest upstream
```

### Neovim plugins (lazy.nvim)

Plugin specs in `nvim/.config/nvim/lua/plugins/*.lua` are auto-discovered.
No manual install needed -- lazy.nvim installs on startup.

```sh
nvim +"Lazy"            # plugin UI
nvim +"Lazy sync" +qall # update all plugins headless
```

### Reload configs without restarting

- **zsh**: `source ~/.zshrc` (or alias `reloadzsh`)
- **tmux**: `<prefix> r` or `tmux source-file ~/.tmux.conf`
- **nvim**: `:source $MYVIMRC` or restart

## Commit conventions

Conventional commit prefixes with **lowercase** messages, no scope parentheses:

```
feat: add fzf-tab plugin
fix: correct tmux pane splitting on mac
chore: update submodules
```

Prefixes: `feat`, `fix`, `chore`, `docs`, `refactor`. Under 72 characters.

## Code style

### Shell (zsh)

- `# Section name` for headers -- single-line comments, no decorative banners.
- Group related aliases under a sub-comment (e.g. `# Docker`, `# Kubernetes`).
- Double-quote variables and strings: `"$HOME/path"`, `"$ZSH"`.
- Use `$HOME` instead of `~` in exports and variable assignments.
- 2-space indentation inside functions and control structures.
- Functions use `function name() { }` form.
- Use `command -v` for command existence checks, not `which`.
- Keep `.stow-local-ignore` updated if adding dirs that should not be symlinked.

### Neovim (Lua)

- Pure Lua config targeting Neovim 0.11+. No VimScript.
- `init.lua` is a single `require("config.lazy")` -- all setup flows from there.
- Core settings in `lua/config/`, plugin specs in `lua/plugins/*.lua`.
- 4-space indentation, double-quoted strings in all Lua files.
- `mapleader = " "` (Space), `maplocalleader = "\\"` (backslash).
- Line length guide: `colorcolumn = "120"`.
- Disabled providers: perl, ruby, python3.
- LSP uses native `vim.lsp.config()` / `vim.lsp.enable()` API (not the
  deprecated `require('lspconfig').<server>.setup()` pattern).
- Mason installs LSP servers, but ruff is installed externally via
  `uv tool install ruff` and enabled with `vim.lsp.enable("ruff")`.
- Prefer `opts = {}` in lazy.nvim specs over `config = function()` when the
  setup call takes a plain table. Use `config` only for extra logic.
- Use `event`, `keys`, `cmd`, or `ft` for lazy loading. Always provide
  `desc = "..."` in keymap definitions.

### Tmux

- Prefix is `C-a` (not default `C-b`).
- Vim-tmux-navigator: pane switching via `C-h/j/k/l` (shared with neovim).
- Vi mode for copy mode (`mode-keys vi`).
- Windows/panes are 1-indexed. `escape-time 0`.
- TPM (tmux plugin manager) with `tmux-yank` plugin.

### Git config

- GPG signing enabled (`commit.gpgsign = true`).
- SSH for all GitHub URLs (`url.ssh://git@github.com/.insteadOf`).
- Fast-forward only pulls (`pull.ff = only`).
- Difftastic is the default diff viewer (`diff.external = difft`).
  `git diff` and oh-my-zsh aliases (`gd`, `gds`) use difftastic.
  Use shell alias `gdd` for standard patch-format diff.

## Things to avoid

- **No secrets or keys.** Never add private keys, tokens, or credentials.
- **No hardcoded absolute paths.** Use `$HOME`, `$GOPATH`, etc. Exception:
  `/opt/homebrew/bin/brew` (standard macOS ARM Homebrew path).
- **No modifications to submodule contents.** Configure plugins externally.
- **No generated or cache files.** `.gitignore` excludes `.DS_Store`,
  `.mypy_cache`, `.netrwhist`. Add similar patterns for new tools.
- **No package manager lock files.** This repo manages only config files.

## Environment context

Target: macOS (Apple Silicon), iTerm2 + tmux + zsh (Pure prompt).

- Homebrew at `/opt/homebrew`
- Assumed tools: `fzf`, `fd`, `rg`, `zoxide`, `jq`, `difft`, `go`, `nvm`/`node`,
  `uv`, `kubectl`, `docker`, `stow`
