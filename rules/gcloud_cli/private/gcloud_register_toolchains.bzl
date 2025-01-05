load(
    "//rules/gcloud_cli:versions.bzl",
    "CLI_VERSIONS",
    "CLI_PLATFORMS",
    "LATEST_CLI_VERSION",
    "get_repository_info",
)
load("//rules/gcloud_cli/private:gcloud_cli_repository.bzl", "gcloud_cli_repository")
load("//rules/gcloud_cli/private:toolchains_repo.bzl", "toolchains_repo")


def gcloud_cli_register_toolchains(
    name = None,
    version = None,
    cli_versions = None):
    """
    Register Gcloud CLI as a bazel toolchain.

    Args:
        name:
        version:
        cli_versions:
    """
    name = name or "gcloud_cli"
    version = version or LATEST_CLI_VERSION
    cli_versions = cli_versions or CLI_VERSIONS

    toolchain_repo_name = "{name}_toolchains".format(name = name)

    loaded_platforms = []

    for platform in CLI_PLATFORMS.keys():
        sha256 = cli_versions[version]["sha256"].get(platform, None)
        if not sha256:
            continue

        loaded_platforms.append(platform)

        url, sha256, strip_prefix = get_repository_info(version=version, platform=platform)

        gcloud_cli_repository(
            name = "{name}_{platform}".format(
                name = name,
                platform = platform,
            ),
            url = url,
            sha256 = sha256,
            strip_prefix = strip_prefix,
        )

        native.register_toolchains("@{toolchain_repo_name}//:{platform}_toolchain".format(
            toolchain_repo_name = toolchain_repo_name,
            platform = platform,
        ))


    toolchains_repo(
        name = toolchain_repo_name,
        version = version,
        repository_name = name,
        loaded_platforms = loaded_platforms,
    )
