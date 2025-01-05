

def _gcloud_upload_impl(ctx):
    gcloud_cli_info = ctx.toolchains["//rules/gcloud_cli:toolchain_type"].gcloud_cli_info

    gcloud_cli_path = gcloud_cli_info.gcloud_path

    srcs = ctx.attr.src.files.to_list()

    substitutions = {
        "%{gcloud_path}": gcloud_cli_path.files_to_run.executable.short_path,
        "%{src}": srcs[0].short_path,
        "%{dst}": "gs://{bucket}/{dest}".format(
            bucket = ctx.attr.bucket,
            dest = ctx.attr.dest,
        )
    }

    ctx.actions.expand_template(
        output = ctx.outputs.copy_sh,
        template = ctx.file._gcloud_upload_template,
        substitutions = substitutions,
        is_executable = True,
    )

    target_runfiles = ctx.runfiles(files = ctx.files.src)
    command_runfiles = ctx.runfiles(files = [gcloud_cli_path.files_to_run.executable])

    runfiles = target_runfiles.merge(command_runfiles)

    return [
        DefaultInfo(
            runfiles = runfiles,
            executable = ctx.outputs.copy_sh,
        )
    ]


gcloud_upload = rule(
    implementation = _gcloud_upload_impl,
    attrs = {
        "src": attr.label(allow_single_file = True),
        "bucket": attr.string(),
        "dest": attr.string(),
        "_gcloud_upload_template": attr.label(
            default = Label("//rules/gcloud_cli/private/gcloud_upload:gcloud_upload.sh.template"),
            allow_single_file = True,
        ),
    },
    outputs = {
        "copy_sh": "gcloud_%{name}.sh",
    },
    toolchains = ["//rules/gcloud_cli:toolchain_type"],
    executable = True,
)
