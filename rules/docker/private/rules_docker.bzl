load("@bazel_skylib//lib:paths.bzl", "paths")

DockerToolchainInfo = provider(
    doc = "Provider for Docker toolchain",
    fields = {
        'command_path' : 'path to docker command',
    }
)

def _docker_toolchain_impl(ctx):
    toolchain_info = platform_common.ToolchainInfo(
        dockerinfo = DockerToolchainInfo(
            command_path = ctx.attr.command_path,
        ),
    )
    return [toolchain_info]

docker_toolchain = rule(
    implementation = _docker_toolchain_impl,
    attrs = {
        "command_path":attr.string(),
    },
)


DockerfileInfo = provider(
    doc = "Provider for Dockerfile",
    fields = {
        'filename': '',
        'prefix' : 'tags defined for this image',
        'path': '',
    }
)


def _docker_template_impl(ctx):
    dockerfile = ctx.outputs.docker_path
    values_json = json.encode(ctx.attr.values)

    json_file = ctx.actions.declare_file(paths.join(ctx.attr.prefix, ctx.label.name + ".json"))
    ctx.actions.write(json_file, values_json)

    args = ctx.actions.args()
    args.add(ctx.files.template[0])
    args.add(json_file)
    args.add(dockerfile)

    ctx.actions.run(
        outputs = [dockerfile],
        inputs = [ctx.files.template[0], json_file],
        arguments = [args],
        executable = ctx.executable._template_engine,
        mnemonic = "DockerTemplate",
    )

    return [
        DefaultInfo(files = depset([dockerfile])),
        DockerfileInfo(
            filename = ctx.attr.dockerfile,
            prefix = ctx.attr.prefix,
            path = dockerfile,
        ),
    ]


docker_template = rule(
    implementation = _docker_template_impl,
    attrs = {
        "template": attr.label(
            allow_files = [".jinja"],
        ),
        "values": attr.string_dict(),
        "dockerfile": attr.string(),
        "prefix": attr.string(),
        "_template_engine": attr.label(
            default = Label("//tools/template"),
            executable = True,
            cfg = "exec",
        ),
    },
    outputs = {
        "docker_path": paths.join("%{prefix}", "%{dockerfile}"),
    },
)


DockerImageInfo = provider(
    fields = {
        'tags' : 'tags defined for this image',
    }
)


def _docker_container_file_impl(ctx):
    toolchain = ctx.toolchains["//rules/docker:toolchain_type"].dockerinfo

    prefix = ctx.attr.dockerfile[DockerfileInfo].prefix
    dockerfile_path = ctx.attr.dockerfile[DockerfileInfo].path
    tar_file = ctx.actions.declare_file(paths.join(prefix, prefix + ".tar"))

    docker_executable = toolchain.command_path #$1
    dockerfile_dir =  ctx.file.dockerfile.dirname #$2
    image_name = ctx.attr.image_tag #$3
    path_in_container = ctx.attr.path_in_container #$4
    output_file = ctx.outputs.output_file #$5
    print(ctx.attr.output)

    args = ctx.actions.args()
    args.add(docker_executable)
    args.add(dockerfile_dir)
    args.add(image_name)
    args.add(path_in_container)
    args.add(tar_file)
    args.add(output_file)

    # Execute docker build command with the given Dockefile
    ctx.actions.run(
        outputs = [tar_file, output_file],
        inputs = [ctx.file.dockerfile],
        tools = [ctx.file._runner],
        arguments = [args],
        executable = ctx.file._runner.path,
        mnemonic = "DockerBuild",
    )

    return [
        DefaultInfo(files = depset([output_file])),
        DockerImageInfo(tags = [ctx.attr.image_tag]),
    ]


docker_container_file = rule(
    implementation = _docker_container_file_impl,
    attrs = {
        "dockerfile": attr.label(
            allow_single_file = True,
        ),
        "prefix": attr.string(),
        "image_tag": attr.string(),
        "path_in_container": attr.string(),
        "_runner": attr.label(
            default = "docker_runner.sh",
            allow_single_file = True,
            executable = True,
            cfg = "exec",
        ),
        "output": attr.string(),
    },
    outputs = {
        "output_file": paths.join("%{prefix}", "%{output}"),
    },
    toolchains = ["//rules/docker:toolchain_type"],
)
