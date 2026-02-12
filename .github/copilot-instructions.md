# Copilot Instructions

This file mirrors `AGENTS.md`. `AGENTS.md` is canonical.

## Scope

- Use this repo as a skill catalog and install source.
- Use `SKILLS.md` for discovery.
- Use `<skill-name>/SKILL.md` for task execution details.

## Usage Flow

1. Read `README.md`.
2. Locate the skill in `SKILLS.md`.
3. Open `<skill-name>/SKILL.md`.
4. Load `references/` only when necessary.

## Install Rules

- Use:
  - `python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py`
- Repo form:
  - `--repo leoustc/skills`
- URL form:
  - `https://github.com/leoustc/skills/tree/main/<skill-path>`
- `--path` must resolve to a folder containing `SKILL.md`.
- Restart Codex after install.

## Behavior Expectations

- Keep output focused on using and installing skills.
- Avoid development/authoring instructions unless explicitly requested.
