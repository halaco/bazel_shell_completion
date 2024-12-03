

def _google_cloud_storage_upload_impl(ctx):

    return [
        DefaultInfo(executable = executable, ...),
    ]

google_cloud_storage_upload = rules(
    implementation = _google_cloud_storage_upload_impl,
    attrs = {
        "src": attr.label(allow_single_file = True),
        "bucket": attr.string(),
        "folder": attr.string(),
    },
    toolchains = ["//rules/gcloud_cli:toolchain_type"],
    executable = True,
)
