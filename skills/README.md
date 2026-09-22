# Skills

Claude Code skills, symlinked into `~/.claude/skills/` by `home-manager/claude.nix`.
Subagent definitions live in `../agents/` and go to `~/.claude/agents/`.

## Credit

These skills are a port of **pstack** by [@poteto](https://x.com/poteto) (Lauren Tan) from
[cursor/plugins](https://github.com/cursor/plugins/tree/main/pstack). The playbooks, principles,
and prose are hers. The port only changes what Cursor-specific mechanics needed to run under
Claude Code. Read her [pstack guide](https://github.com/cursor/plugins/tree/main/pstack/docs/guide)
for how the method is meant to be used.

Upstream: `https://github.com/cursor/plugins` at commit `53e579f1481697931fc44f5445171397cfa2b24b` (pstack 0.15.2, 2026-09-21).

## Changes from upstream

Tool and path names:

- `Task` → `Agent`. `subagent_type: generalPurpose` → `"general-purpose"`. `AskQuestion` → `AskUserQuestion`.
- `readonly: true` → `subagent_type: "Explore"`. `readonly: false` (agent mode) → `subagent_type: "general-purpose"`.
- `environment: "cloud"` removed. Parallel workers use `isolation: "worktree"` when they edit the same repository.
- `~/.cursor/rules/pstack-models.mdc` → `~/.claude/pstack-models.md`. `.cursor/skills` → `.claude/skills`.
- Transcript paths point at `~/.claude/projects/<slug>/<session>.jsonl` and `<session>/subagents/`.
- Cursor's `create-skill` → the `writing-for-agents` skill. `cursor-team-kit`'s `deslop` → `/simplify`.
  `control-ui` / `control-cli` → the project's `verify-*` skill or the `agent-browser` tools.

Models. Claude Code's `Agent` tool accepts `fable`, `opus`, `sonnet`, and `haiku`, so the
multi-vendor panels collapse to Claude models:

| upstream role | upstream default | here |
|---|---|---|
| code delegates | `grok-4.6-fast-xhigh` | `opus` |
| judgment and prose | `claude-fable-5-1-thinking-max` | `fable` |
| panels (arena, architect, interrogate) | fable / sol / grok / opus 5 | `fable`, `opus`, `sonnet` |

`setup-pstack` is rewritten around that model set.

Frontmatter. Cursor's `mode`, `icon`, `color`, `reminder`, and `is_background` fields are removed.
The sticky-mode reminder moved into the body of `poteto-mode`. `disable-model-invocation: true`
is kept only on user-entry skills (`automate-me`, `bro`, `maintain-verification-skill`,
`poteto-teach`, `recall`, `reflect`, `setup-pstack`), because Claude Code hides such skills from
the model and `poteto-mode` routes to the others by name.

Renames and removals:

- `tdd` → `poteto-tdd` and `teach` → `poteto-teach`, to avoid a clash with the mattpocock skills.
- `make-bot-ui` (Grok Bot webhook) is not included.
- `automations/` (Cursor cloud automations) and `docs/` are not included.

`poteto-mode/scripts/` (orchestration and PR-watch tooling) is copied as-is. It needs `bun`.
