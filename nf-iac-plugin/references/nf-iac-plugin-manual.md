# NF-IAC Plugin Manual (local reference)

This document summarizes the current behavior of the `nf-iac` plugin from source in this repo (`iac-plugin/`).
It is intended as an implementation-level reference.

## What the plugin does

- Provides a Nextflow executor named `iac`.
- Provisions OCI compute per task with Terraform.
- Stores per-task state under `.nextflow/iac/<run_timestamp>/<task_id>/`.
- Uses `nxf_work.sh` (cloud-init/user-data) to:
- pull work/input data from object storage,
- run `.command.run`,
- push outputs and control files back to object storage.
- Runs cleanup (`terraform destroy`) after task completion and again on plugin shutdown.

## Required tooling

- Launcher host:
- `terraform` on `PATH` (checked at startup).
- Worker VM:
- `rclone` (auto-installed by `nxf_work.sh` if missing).
- `docker` if pipeline processes use container execution.

## Required configuration

Required keys:

- `iac.sshAuthorizedKey`
- `iac.oci.profile`
- `iac.oci.compartment` or `iac.oci.compartment_id`
- `iac.oci.subnet` or `iac.oci.subnet_id`
- `iac.oci.image` or `iac.oci.image_id`

Defaults:

- `iac.oci.defaultShape`: `1 VM.Standard.E4.Flex`
- `iac.oci.defaultDisk`: `1024 GB`
- `iac.cpu_factor`: `1`
- `iac.ram_factor`: `1`

## Task resource mapping

Task config -> Terraform vars:

- `cpus` -> `ocpus`
- formula: `scaledOcpus = max(1, round(baseOcpus * cpu_factor))`
- `memory` -> `memory_gbs`
- formula: `memoryGbs = max(1, round(baseMemGbs * ram_factor))`
- `disk` -> `image_boot_size`
- formula: task `disk` if set, else `defaultDisk`, and `min 200 GB`

Shape/node resolution:

- Default comes from `iac.oci.defaultShape` format: `"<num_node> <shape>"`
- Process override via `process.ext.shape`
- GPU override via `accelerator.type`
- `num_node` from `accelerator.request` when set, otherwise from `defaultShape`
- Per-task override also supported for `profile`, `compartment`, `subnet`, `image` through `process.ext.*`

## Object storage behavior (rclone only)

`nxf_work.sh` is now fully rclone-based (no AWS CLI S3 calls).

Rclone config generation:

- Writes `/etc/rclone/rclone.conf` on worker.
- Builds one `[s3]` remote from `aws {}` + `aws.client {}` defaults.
- Builds one remote per `iac.storage` entry using the bucket name as remote name.
- Each `iac.storage` entry requires:
- `bucket`, `region`, `accessKey`, `secretKey`, `endpoint`

Rclone path model:

- Remote path resolver prefers `<bucket>` remote if present, else falls back to `s3`.
- Object paths use `bucket:bucket/<key>` style, for example:
- `nf-data:nf-data/work-demo/...`

Retry behavior:

- Uses rclone native retry flags:
- `--retries 5 --retries-sleep 2s --low-level-retries 5`

Input handling:

- Inputs are collected into `INPUT_S3_PATHS`.
- For each `s3://bucket/key` input:
- If remote path is a directory (`lsf --dirs-only`) -> `rclone sync`.
- Otherwise -> `rclone copyto` (file path).

Exit handling:

- `trap 'CODE=$?; send_exitcode "$CODE"' EXIT`
- `send_exitcode` writes `.exitcode`, uploads:
- `.command.out`, `.command.err`, `.command.trace`, `.command.log`, `.nxf.log`, `.exitcode`
- then exits `0` (best-effort upload).

Normal success path:

- When task RC is `0`, script syncs full `$WORKDIR` back to remote (excluding `.exitcode`, skipping links), then calls `send_exitcode`.

## Files written per task

Under `.nextflow/iac/<run_timestamp>/<task_id>/`:

- `tfvars.json`
- `nxf_work.sh`
- `.iac.run`, `.iac.clean`
- `.iac.resource.meta`
- `.iac.out`, `.iac.err`, `.exitcode.iac`

## Terraform template notes (`oci/bot.tf`)

- `image_boot_size` maps to OCI `boot_volume_size_in_gbs`.
- `ocpus` + `memory_gbs` are used for Flex shapes.
- `num_node > 1` with BM shape uses compute cluster logic.
- `user_data` is generated `nxf_work.sh` (base64).

## Run-level logs and metrics

Per run directory:

- `.nextflow/iac/<run_timestamp>/`

Resource usage file:

- `pipeline-resource-usage-<run_timestamp>.txt`
- Header columns:
- `Task CPU LCPU RAM(GB) DISK(GB) PEAK_RSS(GB) PEAK_VMEM(GB) CPU_TIME CPU_GHZ CPU_CYCLES_EST STARTTIME(min) RUNTIME(min) %CPU CPUAVG %RSS %VMEM %DISK`
- `%` columns are written with full precision.

Trace usage file:

- `pipeline-trace-usage-<run_timestamp>.txt`
- Format per task:
- `=== <task> ===`
- raw `.command.trace` lines

## Source-level map

- `src/main/groovy/leoustc/plugin/IacTaskHandler.groovy`
- `submit()`: task lifecycle wiring.
- `buildIacWrapper()`: writes per-task assets and `nxf_work.sh`.
- `resolveRunTimestampDir()`: run folder naming.
- `src/main/groovy/leoustc/plugin/IacBackendWrapper.groovy`
- `triggerSubmit()`: starts task wrapper.
- `triggerClean()`: cleanup + usage/trace aggregation.
- `recordResourceMeta()`: writes `.iac.resource.meta`.
- `recordTraceUsage()`: appends raw trace blocks.

## Reference config template

```groovy
plugins {
  id 'nf-iac@1.0.2'
  id 'nf-amazon@3.4.1'
}

process {
  executor = 'iac'
}

aws {
  region = System.getenv('AWS_REGION')
  accessKey = System.getenv('AWS_ACCESS_KEY_ID')
  secretKey = System.getenv('AWS_SECRET_ACCESS_KEY')
  client {
    endpoint = System.getenv('AWS_ENDPOINT')
    s3PathStyleAccess = true
  }
}

iac {
  namePrefix = 'nf-iac'
  sshAuthorizedKey = 'ssh-ed25519 AAAA...'

  storage = [
    [bucket: 'nf-data', region: System.getenv('AWS_REGION'), accessKey: System.getenv('AWS_ACCESS_KEY_ID'), secretKey: System.getenv('AWS_SECRET_ACCESS_KEY'), endpoint: System.getenv('AWS_ENDPOINT')],
    [bucket: 'ngi-igenomes', region: System.getenv('AWS_REGION'), accessKey: System.getenv('AWS_ACCESS_KEY_ID'), secretKey: System.getenv('AWS_SECRET_ACCESS_KEY'), endpoint: System.getenv('AWS_ENDPOINT')]
  ]

  oci {
    profile = 'MIRXES'
    compartment = System.getenv('COMPARTMENT_OCID')
    subnet = System.getenv('SUBNET_OCID')
    image = 'ocid1.image.oc1.ap-singapore-1.aaaa...'
    defaultShape = '1 VM.Standard.E4.Flex'
    defaultDisk = '1024 GB'
  }
}
```
