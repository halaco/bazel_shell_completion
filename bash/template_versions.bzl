
load("//rules/docker:defs.bzl", "docker_template", "docker_container_file")
load("//rules/gcloud_cli:defs.bzl", "gcloud_upload")

def template_versions(name, docker_file_template, bazel_versions):

    images = []

    for version in bazel_versions:
        print(version)
        prefix = "bazel." + version
        dockerfile_name = "Dockerfile"
        template_step_name = name + ".template." + version

        docker_template(
            name = template_step_name,
            template = docker_file_template,
            dockerfile = dockerfile_name,
            prefix = prefix,
            values = {
                "bazel_version": version,
            },
        )

        generate_step_name = name + "." + version
        print("bazel." + version)
        docker_container_file(
            name = generate_step_name,
            dockerfile = template_step_name,
            prefix = prefix,
            image_tag = generate_step_name,
            path_in_container = "/opt/bazel/bash_complation.d/bazel." + version,
            output = "bazel." + version,
        )

        gcloud_upload(
            name = generate_step_name + ".upload",
            src = ":" + generate_step_name,
            bucket = "download-6e93fb8c",
            dest = "bazel_" + generate_step_name,
        )
