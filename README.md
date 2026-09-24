# dotfiles
Main setup runs this on macOS with Ghostty and zsh+tmux

## Claude Code MCP servers

Claude Code stores user-wide MCP servers in `~/.claude.json`. Set them up once
on a new machine with the commands below, based on the MCPs in
`opencode/.config/opencode/opencode.json`. They do not change project-local
MCP servers; those can be added separately with `claude mcp add` (local scope)
or a project's `.mcp.json` (project scope).

```sh
claude mcp add --scope user --transport http tickup https://mcp.etl.tickup.net/mcp
claude mcp add --scope user --transport http clickhouse-docs https://clickhouse.mcp.kapa.ai/
claude mcp add --scope user ask_polars -- uvx --with 'mcp<2' --with polars polars-mcp
claude mcp add-json --scope user github \
  '{"type":"stdio","command":"docker","args":["run","-i","--rm","-e","GITHUB_PERSONAL_ACCESS_TOKEN","ghcr.io/github/github-mcp-server"],"env":{"GITHUB_PERSONAL_ACCESS_TOKEN":"${GITHUB_TOKEN_MCP}"}}'
claude mcp add --scope user --transport http linear https://mcp.linear.app/mcp
claude mcp add --scope user --transport sse tickup-basedoc https://basedoc-mcp.tickup.net/sse
claude mcp add-json --scope user context7 \
  '{"type":"http","url":"https://mcp.context7.com/mcp","headers":{"CONTEXT7_API_KEY":"${CONTEXT7_API_KEY}"}}'
claude mcp add --scope user --transport http infra-basedoc https://infradoc.tickup.net/mcp
claude mcp add --scope user --transport http tickup-docs-wiki https://docs.tickup.io/mcp
```

The GitHub and Context7 variables come from the macOS Keychain via
`zsh/.zshrc`; make them available to Claude if launching outside that shell.
The single quotes above keep `${VAR}` references in Claude's config rather
than expanding them while running the setup commands. Authenticate OAuth
servers with `claude mcp login <name>` (or `/mcp` inside Claude) and check
connections with `claude mcp list`. To change a user-wide server later,
remove that specific entry with `claude mcp remove --scope user <name>` and
add it again. Keep `~/.claude.json` out of Git: it also stores local app state.
