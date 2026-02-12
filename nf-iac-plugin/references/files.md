# Files Reference

## Self-contained baseline

Always available inside this skill:

- `references/usage.md`
- `references/debug.md`
- `references/nf-iac-plugin-public-readme.md`
- `references/nf-iac-plugin-manual.md`
- `references/nf-iac-plugin-user-manual.md`
- `references/nf-iac-plugin-readme.md`

## Optional repository files

Use these if they exist in the target repo:

- `README.md`
- `manual/*.md`
- `test/*/iac.conf`
- `test/*/*.config`
- `test/*/run*.sh`
- `test/*/Makefile`
- `test/*/environment`

## Runtime paths created during runs

Inside the folder where `nextflow run` is started:
- `.nextflow.log`
- `.nextflow/`
- `.nextflow/iac/<timestamp>/`
- `.nextflow/iac/<timestamp>/<task_id>/`

Per-task artifacts:
- `tfvars.json`
- `nxf_work.sh`
- `.iac.run`, `.iac.clean`
- `.iac.out`, `.iac.err`, `.exitcode.iac`

Per-run artifacts:
- `pipeline-resource-usage-<timestamp>.txt`
- `pipeline-trace-usage-<timestamp>.txt`
