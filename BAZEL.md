# Bazel Configurations

### `.local.bazelrc` vs `.remote.bazelrc`

TBD

## Remote Build

### Set up BuildBuddy

To build this project on the BuildBuddy.
You need to add `.remote.bazelrc` at the top directory.
Its content should be like this:

```
build:linux --workspace_status_command=$(pwd)/workspace_status.sh

build --bes_results_url=https://app.buildbuddy.io/invocation/
build --bes_backend=grpcs://remote.buildbuddy.io
build --remote_cache=grpcs://remote.buildbuddy.io
build --remote_timeout=3600
build --remote_header=x-buildbuddy-api-key=<<BuildBuddy API Key>>
build --jobs=300
```

Since this file contains the BuildBuddy API key and remote execute
is note suitable for all development environment, `.remote.bazelrc`
is added to `.gitignore` in advance.

## Other Issues

### Workaround for Docker / devcontainer on MacOS Sequoia 15.2.

Add the following code into `.local.bazelrc`
```
# Workaround for JVM crashing issue with Docker Container on MacOS Sequoia 15.2.
# Details are desribed in:
# https://medium.com/@luketn/java-on-docker-sigill-exception-on-mac-os-sequoia-15-2-9311e4775442
startup --host_jvm_args='-XX:UseSVE=0'
```
