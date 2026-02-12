# skills

Skill collection for tools built for AI infra and beyond.

## Layout

- `SKILLS.md`: root catalog and discovery index
- `<skill-name>/SKILL.md`: required skill definition used by Codex

## Agent Files

- `AGENTS.md`: operating instructions for AI agents in this repository
- `CLAUDE.md`: compatibility alias pointing to `AGENTS.md`
- `CURSOR.md`: compatibility alias pointing to `AGENTS.md`
- `.github/copilot-instructions.md`: Copilot-facing instructions synced with `AGENTS.md`

## How To Use

1. Open `SKILLS.md` and find the skill by tool name or use case.
2. Mention the skill name in your prompt (for example: `ssh-tunnel-gateway`) or ask a task that clearly matches its description.
3. Codex reads `<skill-name>/SKILL.md` first.
4. Codex loads `references/` only when needed and runs `scripts/` when deterministic execution is better than ad-hoc generation.

## Install Skills Into Codex

Install this repo's example skill from `leoustc/skills`:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo leoustc/skills \
  --path ssh-tunnel-gateway
```

Install the `nf-iac-plugin` skill:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo leoustc/skills \
  --path nf-iac-plugin
```

Install from a full GitHub URL:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --url https://github.com/leoustc/skills/tree/main/ssh-tunnel-gateway
```

Install all skills listed in `SKILLS.md`:

```bash
python3 ~/.codex/skills/.system/skill-installer/scripts/install-skill-from-github.py \
  --repo leoustc/skills \
  --path $(
    awk -F'`' '/\|/ && $2 ~ /^\.\/.*\/SKILL\.md$/ {
      p=$2
      sub("^\\./","",p)
      sub("/SKILL\\.md$","",p)
      print p
    }' SKILLS.md
  )
```

Notes:
- The selected folder must contain `SKILL.md`.
- Skills install to `~/.codex/skills/<skill-name>`.
- Use `leoustc/skills` for `--repo` (no `.git` suffix).
- Restart Codex after install so new skills are loaded.

## Download Packaged Zip

- Workflow: `.github/workflows/package-skills.yml`
- Triggers:
  - Manual run (`workflow_dispatch`)
  - Push to `main`
  - Tag push matching `v*`
- Outputs:
  - `skills-<short-sha-or-tag>.zip`
  - `skills-<short-sha-or-tag>.zip.sha256`
- Zip content source:
  - Skill folders listed in `SKILLS.md`
  - Runtime docs (`SKILLS.md`, `README.md`, `AGENTS.md`, `CLAUDE.md`, `CURSOR.md`)
- On tag pushes (`v*`), a GitHub Release is also created and these files are attached.
- Artifacts are downloadable from the workflow run page in GitHub Actions.
