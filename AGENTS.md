# AGENTS.md

Personal macOS dotfiles repo. It has no application build, lint, or test pipeline;
changes are config-only and deploy to `$HOME` with GNU Stow.

## Boundaries

- Worktree edits are limited to `/Users/hugo/dotfiles` unless explicitly
  requested otherwise.
- Read-only inspection outside the repo is allowed when the user explicitly
  asks to debug deployed config or runtime state, including files under
  `$HOME/.config`, `$HOME/.local/share`, and similar locations.
- Do not edit deployed symlink targets under `$HOME/.config`,
  `$HOME/.local/share`, etc.; make persistent config changes in this dotfiles
  repo instead.
- Top-level directories are Stow packages whose internal paths mirror `$HOME`.
- `.ignore` excludes `zsh/oh-my-zsh/` and `zsh/plugins/` from `rg`/`fd`; those
  paths are submodules, not local source to edit.
- Never modify submodule contents. Configure zsh plugins from `zsh/.zshrc`.
- Do not add secrets, private keys, tokens, generated caches, or local machine
  state. Existing `opencode` MCP config should not be used as a pattern for
  adding more inline credentials; prefer environment interpolation.

## Packages

- `bin/` -> `$HOME/.local/bin/`; contains `tmux-sessionizer`, `tmux-equalize-panes`,
  `herdr-navigate`, `herdr-split`, and `herdr-sessionizer`.
- `ghostty/` -> `$HOME/.config/ghostty/config`.
- `git/` -> `$HOME/.config/git/config`.
- `herdr/` -> `$HOME/.config/herdr/config.toml`; only the file is stowed because
  herdr keeps sockets, logs, and `session.json` in that directory.
- `idea/` -> `$HOME/.ideavimrc`; kept as IdeaVim reference config.
- `nvim/` -> `$HOME/.config/nvim/`; Lua config plus committed `lazy-lock.json`.
- `nix/` -> `$HOME/.config/nix/nix.conf`.
- `opencode/` -> `$HOME/.config/opencode/opencode.json`.
- `tmux/` -> `$HOME/.tmux.conf`.
- `zsh/` -> `$HOME/.zshrc`, `$HOME/.config/starship.toml`, and zsh submodules.

## Commands

```sh
stow -d "$HOME/dotfiles" -t "$HOME" zsh
stow -d "$HOME/dotfiles" -t "$HOME" bin ghostty git herdr idea nvim nix opencode tmux zsh
stow -d "$HOME/dotfiles" -t "$HOME" -n -v zsh
```

```sh
git clone --recurse-submodules <url>
git submodule update --remote --merge
```

```sh
nvim +"Lazy"
nvim +"Lazy sync" +qall
```

## Reloading

- zsh: `source ~/.zshrc` or `reloadzsh`.
- tmux: `<prefix> r` or `tmux source-file ~/.tmux.conf`.
- nvim: `:source $MYVIMRC` or restart.

## Neovim

- Entry flow is `init.lua` -> `lua/config/lazy.lua` -> core config in
  `lua/config/` plus auto-discovered plugin specs in `lua/plugins/*.lua`.
- Use Lua only; target Neovim 0.11+ APIs.
- Lua style here is 4-space indentation and double-quoted strings.
- Prefer `opts = {}` in lazy.nvim specs when setup is a plain table; use
  `config = function()` only for extra logic.
- Lazy-load plugins with `event`, `keys`, `cmd`, or `ft`; keymaps need
  `desc = "..."`.
- LSP uses native `vim.lsp.config()` / `vim.lsp.enable()`, not deprecated
  `require("lspconfig").SERVER.setup()`.
- Mason ensures `gopls`, `lua_ls`, `bashls`, and `ts_ls`. External servers
  `ty`, `ruff`, and rustup's `rust_analyzer` are enabled directly.
- Format-on-save is globally controlled by `vim.g.autoformat` and toggled with
  `<leader>uf`.
- Which-key groups include `<leader>f`, `<leader>g`, `<leader>h`, `<leader>q`,
  `<leader>r`, `<leader>t`, `<leader>o`, and `<leader>u`; put new toggles under
  `<leader>u` and avoid new top-level prefixes unless clearly needed.
- `q` macro recording is disabled; `<leader>um` records macros. `q:` is also
  disabled.
- `<C-f>` launches `tmux-sessionizer` in a new tmux window.

## Shell And Tmux

- zsh sources oh-my-zsh from `$HOME/dotfiles/zsh/oh-my-zsh` directly.
- zsh plugin submodules are sourced manually from `$HOME/dotfiles/zsh/plugins/`,
  not through oh-my-zsh's `plugins=(...)` mechanism.
- Shell style in local zsh code: `$HOME` over `~` in assignments, quote variables,
  `function name() { ... }`, 2-space indentation, and `command -v` over `which`.
- Keep `zsh/.stow-local-ignore` updated when adding directories that Stow should
  not symlink.
- Tmux prefix is `C-a`; panes/windows are 1-indexed; status bar is at the top.
- `focus-events on` is intentional for Neovim autoread and gitsigns behavior.
- `C-h/j/k/l` is shared with vim-tmux-navigator. `M-h/j/k/l` splits panes and
  preserves the current pane path.
- TPM plugins are `tmux-yank`, `tmux-resurrect`, and `tmux-continuum`.

## Herdr

- Config mirrors tmux: prefix `C-a`, `alt+h/j/k/l` splits, `prefix+H/J/K/L`
  resize, `prefix q` closes a pane, `prefix r` reloads, `prefix w` opens the
  workspace picker.
- `prefix f` (and nvim `<C-f>` inside herdr) runs `herdr-sessionizer` in a
  popup: fzf over the tmux-sessionizer search paths, then focus the workspace
  labelled after the repo or create it there.
- `C-h/j/k/l` run `herdr-navigate`, which sends the key through when the
  focused pane runs vim/nvim/fzf and otherwise focuses the neighbor pane.
  `nvim/.config/nvim/lua/config/herdr.lua` hands focus back to herdr at a
  split edge; it is active only when `$HERDR_PANE_ID` is set and `$TMUX` is not.
- herdr only splits right/down; `herdr-split` does left/up by splitting and
  swapping.
- `prefix a` toggles to the previous workspace (tmux `C-a C-a`; herdr reserves
  prefix twice for a literal `C-a`). This is the local plugin in
  `herdr/plugins/last-workspace/`, which Stow ignores. Register it once per
  machine with `herdr plugin link "$HOME/dotfiles/herdr/plugins/last-workspace"`.
- Validate with `herdr config check`; reload with `herdr server reload-config`.

## Git Config

- GPG signing is enabled by default.
- GitHub HTTPS URLs are rewritten to SSH.
- Pulls are fast-forward only.
- Difftastic is the default diff viewer, so use `git diff --no-ext-diff` or the
  `gdd`/`gdds` aliases when a standard patch diff is needed.

## Commits

- Use conventional lowercase prefixes without scopes: `feat`, `fix`, `chore`,
  `docs`, or `refactor`.
- Keep commit subject lines under 72 characters.
