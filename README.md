# skills

Skill collection for tools built for AI infra and beyond.

## Layout

- `SKILLS.md`: root catalog and discovery index
- `<skill-name>/SKILL.md`: required skill definition used by Codex
- `<skill-name>/references/`: optional deep guidance loaded on demand
- `<skill-name>/scripts/`: optional executable helpers
- `<skill-name>/assets/`: optional templates or static assets

## Agent Files

- `AGENTS.md`: operating instructions for AI agents in this repository
- `CLAUDE.md`: compatibility alias pointing to `AGENTS.md`
- `CURSOR.md`: compatibility alias pointing to `AGENTS.md`
- `.github/copilot-instructions.md`: Copilot-facing instructions synced with `AGENTS.md`
- `SKILL_TEMPLATE.md`: copy/paste starter for new skills
- `PROMPT_EXAMPLES.md`: reusable prompts for common maintenance tasks

## How To Use

1. Open `SKILLS.md` and find the skill by tool name or use case.
2. Mention the skill name in your prompt (for example: `ssh-tunnel-gateway`) or ask a task that clearly matches its description.
3. Codex reads `<skill-name>/SKILL.md` first.
4. Codex loads `references/` only when needed and runs `scripts/` when deterministic execution is better than ad-hoc generation.

## Add A New Skill

1. Create a folder: `<skill-name>/`
2. Add `<skill-name>/SKILL.md` with required frontmatter:

```md
---
name: <skill-name>
description: <when to use this skill and what it does>
---
```

3. Keep `SKILL.md` concise with trigger conditions (`Use This Skill When`), a short workflow, and links to deeper details in `references/`.
4. Add optional `scripts/` for repeatable or fragile operations.
5. Register the skill in root `SKILLS.md` (name, use-when, path).

## Authoring Rules

- One tool/domain per skill folder.
- Prefer one root `SKILLS.md` as the canonical catalog.
- Avoid large monolithic `SKILL.md` files; move detail to `references/`.
- Keep operational commands copy/paste-ready when possible.
