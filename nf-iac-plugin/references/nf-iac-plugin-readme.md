# iac plugin

## Building

To build the plugin:
```bash
make assemble
```

## Testing with Nextflow

The plugin can be tested without a local Nextflow installation:

1. Build and install the plugin to your local Nextflow installation: `make install`
2. Run a pipeline with the plugin: `nextflow run hello -plugins nf-iac@1.0.2`

## Configuration

Example configuration snippet:

```groovy
iac {
  // Provisioning and task-start timeouts
  provisionTimeout = '30 min'
  startTimeout = '10 min'

  // OCI defaults
  oci {
    image = 'ocid1.image.oc1..xxxx'
  }
}

process {
  withName: 'my_task' {
    ext.profile = 'TASK_PROFILE'
    ext.compartment = 'ocid1.compartment.oc1..task_compartment'
    ext.subnet = 'ocid1.subnet.oc1..task_subnet'
    ext.image = 'ocid1.image.oc1..override'
  }
}
```

## Publishing

Plugins can be published to a central plugin registry to make them accessible to the Nextflow community. 


Follow these steps to publish the plugin to the Nextflow Plugin Registry:

1. Create a file named `$HOME/.gradle/gradle.properties`, where $HOME is your home directory. Add the following properties:

    * `npr.apiKey`: Your Nextflow Plugin Registry access token.

2. Use the following command to package and create a release for your plugin on GitHub: `make release`.


> [!NOTE]
> The Nextflow Plugin registry is currently available as preview technology. Contact info@nextflow.io to learn how to get access to it.
> 
