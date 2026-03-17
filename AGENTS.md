# AGENTS.md

Personal dotfiles repository for macOS. Configures zsh, neovim, tmux, git, and
IdeaVim. Deployed to `$HOME` using GNU Stow. No application code, no build
system, no tests.

## Repository structure

Each top-level directory is a Stow package. Internal paths mirror the target
layout relative to `$HOME` (e.g. `git/.config/git/config` -> `~/.config/git/config`).

| Package | Contents | Stow target |
|---------|----------|-------------|
| `bin/` | shell scripts | `~/.local/bin/` |
| `git/` | git config | `~/.config/git/config` |
| `idea/` | IdeaVim config (unused, kept for reference) | `~/.ideavimrc` |
| `nvim/` | neovim config (Lua) | `~/.config/nvim/` |
| `tmux/` | tmux config | `~/.tmux.conf` |
| `zsh/` | zsh config + starship.toml + plugin submodules | `~/.zshrc`, `~/.config/starship.toml` |
| `archive/` | old VimScript nvim config (not deployed) | -- |

**Neovim layout:** `init.lua` -> `config/lazy.lua` (bootstrap) -> `config/options.lua`,
`config/keymaps.lua`, `config/autocommands.lua`, `plugins/*.lua` (one file per
plugin/group, auto-discovered).

**File search note:** `.ignore` at repo root excludes `zsh/oh-my-zsh/` and
`zsh/plugins/` (submodule dirs) from `fd` and `rg` searches. Agents using file
search tools should be aware these directories exist but are external code.

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
`oh-my-zsh` is referenced directly as `$HOME/dotfiles/zsh/oh-my-zsh` in `.zshrc`
(not symlinked by Stow). Plugins are sourced manually from
`$HOME/dotfiles/zsh/plugins/`, not through OMZ's plugin mechanism.

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
- Global options of note: `winborder = "rounded"` (all float borders), `undofile = true`
  (persistent undo), `scrolloff = 8`, `splitright = true`, `splitbelow = true`.
- `vim.g.autoformat = true` enables format-on-save globally by default.
- LSP uses native `vim.lsp.config()` / `vim.lsp.enable()` API (not the
  deprecated `require('lspconfig').<server>.setup()` pattern).
- Mason auto-installs `gopls`, `lua_ls`, `bashls`. External (non-Mason) servers:
  `ruff` and `ty` (Python), both installed via `uv tool install` and enabled with
  `vim.lsp.enable()`. Neovim 0.11 built-in LSP keymaps (`K`, `grr`, `grn`, `gra`)
  are relied upon; only missing bindings are added manually.
- Prefer `opts = {}` in lazy.nvim specs over `config = function()` when the
  setup call takes a plain table. Use `config` only for extra logic.
- Use `event`, `keys`, `cmd`, or `ft` for lazy loading. Always provide
  `desc = "..."` in keymap definitions.
- Keymap groups use `<leader>` prefixes registered in which-key:
  `<leader>f` (find), `<leader>g` (git), `<leader>h` (git hunk),
  `<leader>q` (quickfix), `<leader>t` (test), `<leader>u` (toggle),
  `<leader>o` (opencode). Toggles go under `<leader>u`. When adding keymaps,
  place them in the appropriate existing group rather than creating new top-level
  prefixes.
- Notable toggle keymaps: `<leader>uf` format-on-save, `<leader>uh` inlay hints,
  `<leader>ud` diagnostics, `<leader>gg` lazygit, `<leader>uo` opencode panel.
- `<C-f>` in normal mode launches `tmux-sessionizer` in a new tmux window.
- `<leader>R` reloads `$MYVIMRC`. `q:` is disabled (no-op).

### Tmux

- Prefix is `C-a` (not default `C-b`).
- Vim-tmux-navigator: pane switching via `C-h/j/k/l` (shared with neovim).
- Vi mode for copy mode (`mode-keys vi`).
- Windows/panes are 1-indexed. `escape-time 0`.
- `focus-events on` — required for neovim autoread and gitsigns to work correctly.
- Status bar is at the **top** (not the default bottom); colors match tokyonight-night.
- `renumber-windows on` keeps window indices contiguous after closing.
- `history-limit 50000`. `mouse on`.
- Pane splits via `M-h/j/k/l` (iTerm2 sends these for `Cmd+h/j/k/l`); splits
  preserve the current pane's path.
- `<prefix> H/J/K/L` resize pane by 5 (repeatable). `<prefix> f` opens sessionizer.
- TPM (tmux plugin manager) with `tmux-yank` plugin.

### Git config

- GPG signing enabled (`commit.gpgsign = true`).
- SSH for all GitHub URLs (`url.ssh://git@github.com/.insteadOf`).
- Fast-forward only pulls (`pull.ff = only`).
- Difftastic is the default diff viewer (`diff.external = difft`).
  `git diff` and oh-my-zsh aliases (`gd`, `gds`) use difftastic.
  Use shell alias `gdd` for standard patch-format diff.
- Git aliases: `sla` (recent graph log: `log --oneline --decorate --graph --all -20`),
  `lb` (interactive fzf branch switcher sorted by recency).

## Things to avoid

- **No secrets or keys.** Never add private keys, tokens, or credentials.
- **No hardcoded absolute paths.** Use `$HOME`, `$GOPATH`, etc. Exception:
  `/opt/homebrew/bin/brew` (standard macOS ARM Homebrew path).
- **No modifications to submodule contents.** Configure plugins externally.
- **No generated or cache files.** `.gitignore` excludes `.DS_Store`,
  `.mypy_cache`, `.netrwhist`. Add similar patterns for new tools.
- **No package manager lock files.** This repo manages only config files.
- **No reading files outside this repo.** Never read from `~/.local/share/`,
  `~/.config/` (the deployed symlink targets), or any other path outside
  `/Users/hugo/dotfiles/`. All configuration lives in this repository under
  the stow package directories.

## Environment context

Target: macOS (Apple Silicon), iTerm2 + tmux + zsh (Starship prompt).

- Homebrew at `/opt/homebrew`
- Assumed tools: `fzf`, `fd`, `rg`, `zoxide`, `jq`, `difft`, `go`, `nvm`/`node`,
  `uv`, `kubectl`, `docker`, `stow`
