# NF-IAC Plugin User Manual

This guide focuses on day-to-day usage and debugging of the `nf-iac` executor.

## Quick start

1. Enable plugins and executor.

```groovy
plugins {
  id 'nf-iac@1.0.2'
  id 'nf-amazon@3.4.1'
}

process {
  executor = 'iac'
}
```

2. Configure required IAC/OCI keys.

```groovy
iac {
  namePrefix = 'iac'
  sshAuthorizedKey = 'ssh-ed25519 AAAA...'

  oci {
    profile = 'DEFAULT'
    compartment = 'ocid1.compartment.oc1..aaaa...'
    subnet = 'ocid1.subnet.oc1..aaaa...'
    image = 'ocid1.image.oc1..aaaa...'
    defaultShape = '1 VM.Standard.E4.Flex'
    defaultDisk = '1024 GB'
  }
}
```

3. If workDir or staged inputs are object storage, add storage credentials.

```groovy
iac {
  storage = [
    [
      bucket: 'nf-data',
      region: System.getenv('AWS_REGION'),
      accessKey: System.getenv('AWS_ACCESS_KEY_ID'),
      secretKey: System.getenv('AWS_SECRET_ACCESS_KEY'),
      endpoint: System.getenv('AWS_ENDPOINT')
    ]
  ]
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
```

## Required keys

- `iac.sshAuthorizedKey`
- `iac.oci.profile`
- `iac.oci.compartment` or `iac.oci.compartment_id`
- `iac.oci.subnet` or `iac.oci.subnet_id`
- `iac.oci.image` or `iac.oci.image_id`

## Resource mapping behavior

- `cpus` -> `ocpus` using `round(cpus * cpu_factor)` (min `1`)
- `memory` -> `memory_gbs` using `round(memory_gb * ram_factor)` (min `1`)
- `disk` -> boot volume size (`image_boot_size`) with min `200 GB`
- `accelerator.type` overrides shape
- `accelerator.request` overrides node count

## Storage behavior (important)

The worker script (`nxf_work.sh`) is rclone-based.

- Rclone config path is fixed: `/etc/rclone/rclone.conf`
- No AWS CLI S3 transfer path in runtime script
- Auto-installs rclone if missing (apt first, then official install script)
- Uses native retries:
- `--retries 5 --retries-sleep 2s --low-level-retries 5`

Remote path format:

- Uses `bucket:bucket/path` format
- Example for `s3://nf-data/work-demo/...`:
- `nf-data:nf-data/work-demo/...`

Input path behavior:

- If input key resolves to directory: `rclone sync`
- Else: `rclone copyto` (file)

Exit behavior:

- On any exit, `send_exitcode` writes `.exitcode`
- Uploads only:
- `.command.out`, `.command.err`, `.command.trace`, `.command.log`, `.nxf.log`, `.exitcode`
- Exits `0` after this best-effort upload step

## Where files are written

Per task:

```text
.nextflow/iac/<run_timestamp>/<task_id>/
```

Contains:

- `tfvars.json`
- `nxf_work.sh`
- `.iac.run`, `.iac.clean`
- `.iac.resource.meta`
- `.iac.out`, `.iac.err`, `.exitcode.iac`

## Run-level outputs

Per run:

```text
.nextflow/iac/<run_timestamp>/
```

Files:

- `pipeline-resource-usage-<run_timestamp>.txt`
- `pipeline-trace-usage-<run_timestamp>.txt`

Current resource usage columns:

- `Task CPU LCPU RAM(GB) DISK(GB) PEAK_RSS(GB) PEAK_VMEM(GB) CPU_TIME CPU_GHZ CPU_CYCLES_EST STARTTIME(min) RUNTIME(min) %CPU CPUAVG %RSS %VMEM %DISK`

## Common failure checks

1. `docker: command not found` in `.command.run`
- Worker image is missing Docker while process uses container runtime.

2. Missing staged inputs
- Check `iac.storage` bucket/endpoint/keys.
- Check remote path resolution using `bucket:bucket/path`.

3. Terraform provisioning failures
- Inspect `.iac.err` and `.exitcode.iac` in task job dir.

4. No resource/trace data
- Ensure `.command.trace` exists in workDir and task completed through wrapper flow.

## Practical GPU example

```groovy
process {
  executor = 'iac'

  withName: 'GPU_TASK' {
    accelerator = [type: 'VM.GPU.A10.1', request: 1]
    containerOptions = '--gpus all'
    afterScript = 'hostname >> .command.out; nvidia-smi >> .command.out'
  }
}
```
