---
name: nf-iac-plugin
description: Configure and operate the `nf-iac` Nextflow plugin using bundled references in this skill package. Use for `iac.conf`/`*.config`, run script updates, CPU/GPU profile selection, and debugging from `.nextflow.log` and `.nextflow/iac/*` artifacts.
---

# NF IAC Plugin

## Scope

Use this skill for:
- Plugin usage and configuration decisions.
- Drafting/updating `iac` and `aws` config blocks.
- Adapting run scripts for object-storage work dirs.
- Runtime triage with task/job artifacts and `.nextflow.log`.

This skill is designed to be self-contained. Prefer bundled references under `references/` even when repository docs are missing.

## Optional Repository Discovery

If the target repo also has local templates, discover and use them as secondary input:

1. Look for (if present):
- `README.md` or `public/nf-iac-plugin/README.md`
- `manual/`
- `test/`
- existing run/config files (`run*.sh`, `iac.conf`, `*.config`)

2. Use local files to adapt examples; keep bundled references as baseline truth.

## Workflow

1. Read bundled references in this order:
- `references/usage.md`
- `references/debug.md`
- `references/files.md`
- `references/nf-iac-plugin-public-readme.md`
- `references/nf-iac-plugin-manual.md`
- `references/nf-iac-plugin-user-manual.md`
2. If local templates exist, align edits to their style and naming.
3. Apply changes in usage assets only unless explicitly asked to change source:
- `iac.conf`, `*.config`, `run*.sh`, user docs.
4. For debugging tasks, always inspect:
- `.nextflow.log`
- `.nextflow/iac/<run_timestamp>/`
- `.nextflow/iac/<run_timestamp>/<task_id>/`
5. Keep object-store guidance rclone-based and current:
- config path `/etc/rclone/rclone.conf`
- remote path style `bucket:bucket/path`

## References

- `references/files.md`
- `references/usage.md`
- `references/debug.md`
- `references/nf-iac-plugin-readme.md`
- `references/nf-iac-plugin-public-readme.md`
- `references/nf-iac-plugin-manual.md`
- `references/nf-iac-plugin-user-manual.md`
