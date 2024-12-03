```
load("//rules/gcloud_cli/private/toolchain.bzl", "gcloud_cli_toolchain")

gcloud_cli_toolchain(
    name = "gcloud_cli_linux_x86_64",
    gcloud_path = "/path/to/barc/on/linux",
)

gcloud_cli_toolchain(
    name = "gcloud_cli_windows_x86_64",
    gcloud_path = "C:\\path\\on\\windows\\barc.exe",
)
```



```
toolchain(
    name = "gcloud_cli_linux_toolchain_x86_64"",
    exec_compatible_with = [
        "@platforms//os:linux",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":gcloud_cli_linux_x86_64_x86_64",
    toolchain_type = ":toolchain_type",
)

toolchain(
    name = "cloud_cli_windows_toolchain",
    exec_compatible_with = [
        "@platforms//os:windows",
        "@platforms//cpu:x86_64",
    ],
    toolchain = ":gcloud_cli_windows_x86_64",
    toolchain_type = ":toolchain_type",
)
```
