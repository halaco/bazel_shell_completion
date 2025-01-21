FROM mcr.microsoft.com/devcontainers/base:ubuntu

RUN apt update \
    && apt install -y curl

ENV BAZEL_VERSION="7.2.1"

RUN  mkdir -p /opt/bazel/bash_complation.d \
    && chmod 0755 /opt/bazel/bash_complation.d \
    && curl -fsSL https://storage.googleapis.com/download-6e93fb8c/bazel_bash_completion.${BAZEL_VERSION} -o /opt/bazel/bash_complation.d/bazel.${BAZEL_VERSION} \
    && ln -s /opt/bazel/bash_complation.d/bazel.${BAZEL_VERSION} /etc/bash_completion.d/bazel
