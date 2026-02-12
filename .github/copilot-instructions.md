# Copilot Instructions

This file mirrors repository agent rules in `AGENTS.md`.
`AGENTS.md` is the canonical source of truth.

## Repository Purpose

- Store reusable skills for local tools.
- Keep one skill per folder.
- Keep a single root catalog at `SKILLS.md`.

## First Steps

1. Read `README.md` for repository conventions.
2. Read `SKILLS.md` to understand existing skills and paths.
3. Open only the skill files needed for the user request.

## Skill Authoring Rules

- Every skill folder must include `SKILL.md` with YAML frontmatter:
  - `name`
  - `description`
- Keep `SKILL.md` concise and workflow-oriented.
- Move long details into `references/`.
- Add `scripts/` only for deterministic or repeated tasks.
- Update `SKILLS.md` when adding, renaming, or removing a skill.

## Expected Structure

```text
<skill-name>/
  SKILL.md
  references/   (optional)
  scripts/      (optional)
  assets/       (optional)
```

## Editing Guidelines

- Prefer small, targeted changes.
- Avoid creating extra docs inside skill folders unless directly useful to skill execution.
- Keep examples copy/paste-ready.
- Preserve existing style and naming patterns.

## Definition Of Done

1. The changed skill is registered in `SKILLS.md`.
2. Paths in `SKILLS.md` are correct.
3. `SKILL.md` frontmatter is present and valid.
4. Any referenced files exist.
