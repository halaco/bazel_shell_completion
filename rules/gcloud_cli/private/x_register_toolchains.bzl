

load(
    "//rules/gcloud_cli:version.bzl",
    "TOOLS_VERSIONS",
    "LATEST_VERSION",
)

def gcloud_cli_register_toolchains(
    name,
    version = None,
    tool_versions = None):
    """

    Args:
        name:
        version:
        tool_version:
    """

    version = version or LATEST_VERSION
    tool_versions = tool_versions or TOOLS_VERSIONS

    toolchain_repo_name = "{name}_toolchains".format(name = name)

    loaded_platforms = []
    for platform in PLATFORMS.keys():
        sha256 = tool_versions[version]["sha256"].get(platform, None)
        if not sha256:
            continue

        loaded_platforms.append(platform)

        gcloud_cli_repository(
            name = "{name}_{platform}".format(
                name = name,
                platform = platform,
            ),
            sha256 = sha256,
            patch_strip = patch_strip,
        )

        register_toolchains("@{toolchain_repo_name}//:{platform}_toolchain".format(
            toolchain_repo_name = toolchain_repo_name,
            platform = platform,
        ))

    toolchains_repo(
        name = toolchain_repo_name,
        version = version,
        repository_name = name,
        platforms = loaded_platforms,
    )
