"""
"""

GcloudCliToolchainInfo = provider(
    doc = "Provider for Gcloud CLI toolchain",
    fields = {
        'gcloud_path' : 'path to gcloud command',
    }
)

def _gcloud_cli_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        gcloud_cli_info = GcloudCliToolchainInfo(
            gcloud_path = ctx.attr.gcloud_path,
        ),
    )
    return [toolchain_info]

gcloud_cli_toolchain = rule(
    implementation = _gcloud_cli_toolchain_impl,
    attrs = {
        "gcloud_path": attr.label(),
    },
)
