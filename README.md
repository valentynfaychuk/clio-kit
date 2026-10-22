# clio-kit

Claude Code marketplace `clio-marketplace`, one plugin `clio-kit`: the Clio setup.

## Install

```sh
CLAUDE_CONFIG_DIR=~/.claude-valy claude plugin marketplace add <owner>/clio-kit
CLAUDE_CONFIG_DIR=~/.claude-valy claude plugin install clio-kit@clio-marketplace --scope user
```

Update:

```sh
claude plugin marketplace update clio-marketplace && claude plugin update clio-kit@clio-marketplace
```

Bump `version` in `plugins/clio-kit/.claude-plugin/plugin.json` on every release, or `plugin update` skips it.

## Contents

| Path | Kind | Role |
|---|---|---|
| `output-styles/clio.md` | output style `clio-kit:Clio` | Main thread. Minimal-diff, root-cause fixes, quality over speed. Delegates judgment to valy, facts to oracle, inventive directions to triz, completion review to mnemosyne, PR wording to pr-voice. Holds the GitHub AI-voice rules and footer for comments Clio posts itself. No em dashes. |
| `agents/valy.md` | agent, inherit | Super-ego audit. Lenses: scope, existence check, confidence, claim skepticism, frame, state, diff economy, context discipline, security, delegation. Returns `PROCEED` / `REFRAME` / `STOP`. |
| `agents/oracle.md` | agent, haiku | Retrieval only. Flow is source, then workspace, then query. Caches every external fact in AnythingLLM with source and fetched-at date, skips live state. Returns atomic source-tagged facts. |
| `agents/triz.md` | agent, sonnet | Maps a stated contradiction (improve X, Y degrades) to 2-3 of the 40 TRIZ principles with software analogies. |
| `agents/mnemosyne.md` | agent, inherit | Pre-submission review of diff and artifacts against the brief and repo maturity. Returns `READY` / `GAPS_FOUND` / `BLOCK`. Never edits. |
| `agents/pr-voice.md` | agent, sonnet | Phrases verified findings as PR comments Valy posts himself. Template per finding type, hedged, no body periods, no dashes. |
| `skills/valy`, `skills/mnemosyne` | skills `/clio-kit:valy`, `/clio-kit:mnemosyne` | Run the matching agent spec in an Agent-level fork, so it inherits the full conversation. |
| `.mcp.json` | MCP servers | `anythingllm` (stdio, vendored) and `github` (`https://api.githubcopilot.com/mcp/`, token from `userConfig.github_token`, sensitive). |
| `mcp/anythingllm-mcp-server/` | vendored, MIT | [raqueljezweb/anythingllm-mcp-server](https://github.com/raqueljezweb/anythingllm-mcp-server) 2.0.0 plus local fixes in `src/client.js`: `vector-search` with `topN`, embedding via `document/raw-text` or `document/upload-link` then `update-embeddings`, document list read from the workspace payload. Upstream npm 2.0.0 has the broken routes. |
| `mcp/run-anythingllm-mcp.sh` | launcher | `npm ci --omit=dev` from the lockfile on first run (output to stderr), then `exec node src/index.js`. |
| `bin/oracle-anythingllm` | executable on Bash PATH | Brings up the shared AnythingLLM instance and prints its URL and key. |

## AnythingLLM

One instance serves every project. oracle separates topics by workspace.

1. oracle runs `oracle-anythingllm "${CLAUDE_PLUGIN_DATA}/anythingllm"`. Claude Code substitutes the path into the agent prompt. The variable is not exported to Bash.
2. The script reuses any running container that mounts that dir. Otherwise it starts or restarts `clio-kit-anythingllm` (`mintplexlabs/anythingllm:latest`, `127.0.0.1`, random port, Ollama on the host).
3. On an instance without auth it generates an API key and caches it in `<data>/.oracle-api-key`, mode 600.
4. oracle calls `initialize_anythingllm` with the printed URL and key on every invocation, because the port changes on restart.

No key ships in this repo. The data dir survives updates. `claude plugin uninstall` deletes it unless you pass `--keep-data`.

oracle's `tools` allow only init, list, get, create workspace, list documents, embed, process URL and search. Chat, delete, user, key, agent and system-settings tools are excluded. Plugins cannot ship permission rules, so the main thread still sees all `mcp__plugin_clio-kit_anythingllm__*` tools. Deny them in your own `settings.json` if needed.

## Requirements

Docker, Node.js 18+, Ollama on the host serving `qwen2.5-coder:14b` and `nomic-embed-8k` (`nomic-embed-text` with `num_ctx 8192`).

Overrides: `OLLAMA_BASE_PATH`, `ANYTHINGLLM_LLM_MODEL`, `ANYTHINGLLM_EMBED_MODEL`, `ANYTHINGLLM_IMAGE`.
