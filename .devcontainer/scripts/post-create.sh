#!/usr/bin/env bash
# https://zenn.dev/vol1003/articles/f42f2dd4dcd2f1

git config --global user.name "${GIT_NAME}"
git config --global user.email "${GIT_EMAIL}"

# Fix for docker config.json.
docker_config="$HOME/.docker/config.json"

if [ -f "$docker_config" ]; then
    sed -i s/credsStore/credStore/g $docker_config
fi
