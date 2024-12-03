"""
"""

def _gcloud_cli_repository_rule_impl(repository_ctx):
    repository_ctx.download_and_extract(
        url = CLOUD_SDK_PLATFORM_ARCHIVE,
        output = ".",
        sha256 = CLOUD_SDK_PLATFORM_SHA256,
        stripPrefix = "google-cloud-sdk",
    )
    repository_ctx.template("BUILD", Label("//appengine:cloud_sdk.BUILD"))

gcloud_cli_repository_rule = repository_rule(
    local = False,
    attrs = {
        "version": attr.string(),
        "_cli_build_file": attr.label(
            default = Label("//rules/gcloud_cli/private:BUILD.sdk.bazel"),
        ),
    },
    implementation = _gcloud_cli_repository_rule_impl,
)

def gcloud_cli_repository(version="latest"):
    gcloud_cli_repository(
        name = "io_halaco_google_cloud_cli",
        version = version,
    )
