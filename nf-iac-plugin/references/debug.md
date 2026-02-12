# Debug Reference

Use this with:
- `references/usage.md`
- `references/nf-iac-plugin-public-readme.md`
- `references/nf-iac-plugin-user-manual.md`

## First checks

1. Confirm prerequisites:
- Terraform available on launcher.
- Nextflow can resolve plugin version in config.
- Worker runtime has required container engine for pipeline tasks (for example Docker).

2. Confirm runtime environment variables used by config/run script:
- `AWS_REGION`
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`
- `AWS_ENDPOINT`
- `COMPARTMENT_OCID`
- `SUBNET_OCID`

3. Confirm run command points to the expected config file.

4. Confirm task job folder exists:
- `.nextflow/iac/<timestamp>/<task_id>/`

## Log flow to expect

In `.nextflow.log`, normal sequence includes:
- `Launching run for task ...`
- `Triggering cleanup ... for task ...`
- On plugin stop: `Cleaning task ...`

## Failure triage

- Missing `.exitcode.iac` in job dir:
- provisioning still running, or IAC wrapper did not start.

- `.exitcode.iac` non-zero:
- provisioning failed.
- Inspect `.iac.out` and `.iac.err`.

- Missing workdir `.exitcode`:
- remote task did not finish, or run wrapper did not sync status back.
- inspect generated `nxf_work.sh` and `.command.*` files in workdir.

- `NO_EXITCODE` marker in job dir:
- Workdir `.exitcode` not found when staging logs.

- `FAILURE_<code>` marker:
- Task exit code captured and staged.

- `SUCCESS` marker:
- Task completed with zero exit code.

## Useful files per task

- `.iac.out` / `.iac.err`: Terraform apply/destroy logs.
- `.command.out` / `.command.err` / `.command.log`: task logs copied from work dir.
- `.command.trace`: trace metrics copied and aggregated.
- `.nxf.log`: extra metrics (`lcpu`, cpu usage, disk ratio).
- `tfvars.json`: final resolved resource inputs.
- `nxf_work.sh`: generated runtime script for sync/run/publish.

## Common root causes from usage assets

- Wrong OCI/S3 credentials in config.
- Missing or wrong `sshAuthorizedKey`.
- Wrong `-c` config filename in `run*.sh`.
- Invalid shape/image pairing in `iac { oci { ... } }`.
- GPU `accelerator` set for tasks without compatible container/runtime settings.
- Object-store endpoint/path-style mismatch for rclone remotes.
- Remote path mismatch (`bucket:bucket/path`) causing missing input copy/sync.
