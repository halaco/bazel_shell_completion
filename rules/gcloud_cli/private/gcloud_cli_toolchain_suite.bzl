TARGET_TOOLCHAIN_TYPE = Label("//rules/gcloud_cli:toolchain_type")

def gcloud_cli_toolchain_suite(
    name,
    repository_name,
    prefix,
    target_compatible_with,):

    native.toolchain(
        name = "{prefix}_toolchain".format(prefix = prefix),
        toolchain = "@{repository_name}//:toolchain".format(
            repository_name = repository_name,
        ),
        toolchain_type = TARGET_TOOLCHAIN_TYPE,
        target_compatible_with = target_compatible_with,
    )
