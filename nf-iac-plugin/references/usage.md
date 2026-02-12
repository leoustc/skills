# Usage Reference

This file is a self-contained usage baseline for `nf-iac`.
Use local repo templates (`test/*`, `run*.sh`, `iac.conf`) only as optional overlays.

## Required config

Required baseline:
- `plugins { id 'nf-iac@1.0.2'; id 'nf-amazon@3.4.1' }`
- `process { executor = 'iac' }`
- `iac.sshAuthorizedKey`
- `iac.oci.profile`
- `iac.oci.compartment` or `iac.oci.compartment_id`
- `iac.oci.subnet` or `iac.oci.subnet_id`
- `iac.oci.image` or `iac.oci.image_id`

Runtime prerequisites:
- Nextflow 24.10.0+
- Terraform 1.0+
- OCI profile/compartment/subnet/image
- S3-compatible credentials when using object-storage work dirs
- Worker runtime capable of running containers used by tasks (for example Docker when pipeline uses Docker)

## Common config structure

`aws {}` block:
- `region`, `accessKey`, `secretKey`
- `client.endpoint`
- `client.s3PathStyleAccess = true`

`iac {}` block:
- `pollInterval`, `dumpInterval`, `namePrefix`
- `storage = [ {bucket, region, accessKey, secretKey, endpoint}, ... ]`
- `cpu_factor` and `ram_factor` (default `1`)
- `oci { compartment, subnet, image, profile, defaultShape, defaultDisk }`

`process {}` block:
- CPU tuning via `cpus`, `memory`, `disk`
- GPU task selection via `accelerator = [type: '<OCI GPU shape>', request: 1]`
- GPU container options via `containerOptions = '--gpus all'`
- per-task infrastructure overrides via `ext.profile`, `ext.compartment`, `ext.subnet`, `ext.shape`, `ext.image`

Shape selection precedence:
- `accelerator.type` > `ext.shape` > `iac.oci.defaultShape`

## Runtime transfer behavior (`nxf_work.sh`)

- Rclone config path is fixed to `/etc/rclone/rclone.conf`
- Remote path style is `bucket:bucket/path`
- Uses native retries: `--retries 5 --retries-sleep 2s --low-level-retries 5`
- Pull workdir before run: `rclone sync <remote_dir> <WORKDIR>`
- Input handling:
- directory input -> `rclone sync`
- file input -> `rclone copyto`
- Successful task run syncs full `$WORKDIR` back to remote (excluding `.exitcode`, skip links)
- `send_exitcode` uploads only:
- `.command.out`, `.command.err`, `.command.trace`, `.command.log`, `.nxf.log`, `.exitcode`

## Runtime outputs

Created in the run folder:
- `.nextflow.log`
- `.nextflow/iac/<timestamp>/`
- `.nextflow/iac/<timestamp>/<task_id>/`

Main files:
- `tfvars.json`
- `nxf_work.sh`
- `.iac.run`
- `.iac.clean`
- `.iac.resource.meta`
- `.iac.out`
- `.iac.err`
- `.exitcode.iac`

Per-run usage files:
- `.nextflow/iac/<timestamp>/pipeline-resource-usage-<timestamp>.txt`
- `.nextflow/iac/<timestamp>/pipeline-trace-usage-<timestamp>.txt`

Terminal summary at end of run:
- `-[nf-iac] plugin completed: task resource vs trace summary:`
- columns include:
- `CPU LCPU RAM(GB) DISK(GB) PEAK_RSS(GB) PEAK_VMEM(GB) CPU_TIME CPU_GHZ CPU_CYCLES_EST STARTTIME(min) RUNTIME(min) %CPU CPUAVG %RSS %VMEM %DISK`
