#!/usr/bin/env bash
# https://zenn.dev/vol1003/articles/f42f2dd4dcd2f1

# create .env
cat <<-EOF > .devcontainer/.env
GIT_NAME=$(git config --get user.name)
GIT_EMAIL=$(git config --get user.email)
EOF
