
"""The Gcloud CLI versions we use in the toolchains.
"""
load("@bazel_skylib//lib:paths.bzl", "paths")

DEFAULT_RELEASE_BASE_URL = "https://dl.google.com/dl/cloudsdk/channels/rapid/downloads"
ARCHIVED_RELEASE_BASE_URL = "https://storage.googleapis.com/cloud-sdk-release"

LATEST_CLI_VERSION = "477.0.0"

CLI_VERSIONS = {
    # Actual URLs
    # https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-477.0.0-darwin-arm.tar.gz
    # https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-477.0.0-linux-arm.tar.gz
    # https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-477.0.0-darwin-x86_64.tar.gz
    # https://dl.google.com/dl/cloudsdk/channels/rapid/downloads/google-cloud-cli-477.0.0-linux-x86_64.tar.gz
    "477.0.0": {
        "url": "google-cloud-cli-{version}-{os}-{arch}.{ext}",
        "sha256": {
            "aarch64-apple-darwin": "1f88fa00ffc8db47f257102fecc1b9f652cc393da0b01cde79b518eb21919e66",
            "aarch64-unknown-linux-gnu": "abb7213ff4d7f7f901703611c2b97548a2fbc82a7175bdd6e0368f6381119473",
            "x86_64-apple-darwin": "33529114e7b8b8d262fbc0a5dfab2109d3350e8060797bad5124813416f628bd",
            "x86_64-unknown-linux-gnu": "532fb4bc9f42cfb6bddd5dacaec0dd446f08987e822f99d68fbcfa32a8899c1d",
        },
        "archived": False,
        "strip_prefix" = "google-cloud-sdk",
    }
}

# Values present in the @platforms//os package
MACOS_NAME = "osx"
LINUX_NAME = "linux"
WINDOWS_NAME = "windows"

CLI_PLATFORMS = {
    "aarch64-apple-darwin": struct(
        compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:aarch64",
        ],
        os_name = MACOS_NAME,
        # Matches the value in @platforms//cpu package
        arch = "aarch64",
    ),
    "aarch64-unknown-linux-gnu": struct(
        compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:aarch64",
        ],
        os_name = LINUX_NAME,
        # Matches the value in @platforms//cpu package
        arch = "aarch64",
    ),
    "armv7-unknown-linux-gnu": struct(
        compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:armv7",
        ],
        os_name = LINUX_NAME,
        # Matches the value in @platforms//cpu package
        arch = "arm",
    ),
    "i386-unknown-linux-gnu": struct(
        compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:i386",
        ],
        os_name = LINUX_NAME,
        # Matches the value in @platforms//cpu package
        arch = "x86_32",
    ),
    "x86_64-apple-darwin": struct(
        compatible_with = [
            "@platforms//os:macos",
            "@platforms//cpu:x86_64",
        ],
        flag_values = {},
        os_name = MACOS_NAME,
        # Matches the value in @platforms//cpu package
        arch = "x86_64",
    ),
    "x86_64-pc-windows-msvc": struct(
        compatible_with = [
            "@platforms//os:windows",
            "@platforms//cpu:x86_64",
        ],
        flag_values = {},
        os_name = WINDOWS_NAME,
        # Matches the value in @platforms//cpu package
        arch = "x86_64",
    ),
    "x86_64-unknown-linux-gnu": struct(
        compatible_with = [
            "@platforms//os:linux",
            "@platforms//cpu:x86_64",
        ],
        os_name = LINUX_NAME,
        # Matches the value in @platforms//cpu package
        arch = "x86_64",
    ),
}


def version_repository(version="latest", cli_versions = CLI_VERSIONS, cli_platforms=CLI_PLATFORMS):
    if version == "latest":
        actual_version = LATEST_CLI_VERSION
    else:
        actual_version = version

    cli_repository = cli_versions[actual_version]

    os =
    arch = 
    ext = "tar.gz"

    if cli_repository["archived"]:
        base_url = ARCHIVED_RELEASE_BASE_URL
    else:
        base_url = DEFAULT_RELEASE_BASE_URL

    file_name = cli_repository.url.format(
        version = actual_version,
        os = os,
        arch = arch,
        ext = ext,
    )

    return struct(
        url = paths.join(base_url, file_name),
        sha256 = 
        strip_prefix = cli_repository.strip_prefix,
    )
