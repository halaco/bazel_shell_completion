"""
"""


def _gcloud_cli_repository_impl(repository_ctx):

    workspace = Label("@bazel-shell-completion//:WORKSPACE.bazel")

    repository_ctx.download_and_extract(
         url = repository_ctx.attr.url,
         output = ".",
         sha256 = repository_ctx.attr.sha256,
         stripPrefix = repository_ctx.attr.strip_prefix,
     )

    repository_ctx.template(
        "BUILD.bazel",
        Label("//rules/gcloud_cli/private:BUILD.cli.bazel.template"),
        substitutions = {
            "%{workspace_repo_name}": workspace.repo_name,
            "%{toolchain_name}": repository_ctx.attr.name,
            "%{toolchain_repository}": repository_ctx.attr.name,
        })


gcloud_cli_repository = repository_rule(
    local = False,
    attrs = {
        "url": attr.string(),
        "sha256": attr.string(),
        "strip_prefix": attr.string(),
    },
    implementation = _gcloud_cli_repository_impl,
)

