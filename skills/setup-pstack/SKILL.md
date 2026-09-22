---
name: setup-pstack
description: Configure which Claude model pstack uses per subagent role. Writes ~/.claude/pstack-models.md, which the routed skills read to override their defaults. Use for /setup-pstack, "configure pstack models", or changing pstack's model choices.
disable-model-invocation: true
---

# Setup pstack

Write `~/.claude/pstack-models.md`, a per-role model table that the routed skills (`how`, `why`, `arena`, `swarm`, `architect`, `interrogate`, `reflect`, and the poteto-mode playbooks) read when present.

## Steps

### 1. Load current state

The default role-to-model mapping is the table in step 3. If `~/.claude/pstack-models.md` already exists, read it and treat its role values as the current choices. Otherwise start from the defaults.

### 2. Confirm the roles

The Agent tool accepts four model values: `fable`, `opus`, `sonnet`, and `haiku`. The alias `inherit-parent` means the role runs on the parent chat model (omit `model` on the Agent call).

Show every role with its current value. Ask whether to accept as-is or change specific roles. Prefer `AskUserQuestion` over free text. For panel roles (arena runners, architect runners, interrogate reviewers) the value is a list, and one subagent runs per entry, alias entries included, so the list length sets the count. `arena cross-judge pool` is also a list, but Arena selects one value from it that differs from the parent's model when possible. `swarm workers` is the default model for every worker unless a race or comparison assigns another model per arm.

### 3. Write the file

Write `~/.claude/pstack-models.md` with one line per role, using the same labels the skills use. Overwrite the whole file so re-runs stay idempotent. Shape:

```
# pstack model configuration. One line per role. Delete a line to fall back to the skill default.
# Values: fable, opus, sonnet, haiku, or inherit-parent (omit `model` on the Agent call).
feature, refactoring: opus
bug-fix: opus
perf-issue: opus
hillclimb: opus
judgment and prose: fable
hardest tasks: fable
how explorer: opus
how explainer: fable
why investigators: opus
why synthesizer: fable
reflect tooling: opus
reflect judgment, divergent, synthesizer: fable
arena runners: fable, opus, sonnet
arena cross-judge pool: fable, opus, sonnet
swarm workers: opus
architect runners: fable, opus, sonnet
interrogate reviewers: fable, opus, sonnet
```

### 4. Confirm

Tell the user the file was written and that it applies to new subagent calls. Re-running this skill updates it.

### 5. Offer a verification skill (optional)

Check whether the project has a way to drive the real app for proof (a `verify-*` skill, or an existing harness). If not, offer once: "want a project-local verification skill, so agents can drive the app the way a user does and prove changes work? I can generate one with /create-verification-skill." On yes, invoke `/create-verification-skill`. On no, move on without pushing.
