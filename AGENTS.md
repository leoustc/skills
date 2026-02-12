# AGENTS.md

Runtime instructions for AI agents using this repository.

## Scope

- Use this repo as a skill catalog and install source.
- Default path for discovery is `SKILLS.md`.
- Skill implementation details live in `<skill-name>/SKILL.md`.

## Usage Flow

1. Read `README.md` for installation and usage commands.
2. Find the needed skill in `SKILLS.md`.
3. Open the target `<skill-name>/SKILL.md`.
4. Load `references/` only if needed by the task.

## Install Rules

- Use `python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py`.
- Use `--repo leoustc/skills` (no `.git`) or the full `github.com` URL form.
- `--path` must point to a folder that contains `SKILL.md`.
- Installed location is `~/.codex/skills/<skill-name>`.
- Restart Codex after install.

## Behavior Expectations

- Keep responses focused on using and installing skills.
- Do not introduce development or authoring guidance unless explicitly requested.
