#!/usr/bin/env bash

set -e

eval "$(ssh-agent)"
ssh-add <(echo "$INPUT_GIT_SSH_KEY")

git config --global --add safe.directory /github/workspace

if [ -n "$INPUT_SSH_KNOWN_HOSTS" ] ; then
    echo "$INPUT_SSH_KNOWN_HOSTS" > /known_hosts
    git config --global core.sshCommand "ssh -o UserKnownHostsFile=/known_hosts -o CheckHostIP=no"
else
    git config --global core.sshCommand "ssh -o StrictHostKeyChecking=no -o CheckHostIP=no"
fi

git remote add mirror "$INPUT_REMOTE"

# Extract potentially multiple flags to CONFIG_FLAGS
IFS=' ' read -ra CONFIG_FLAGS <<< "$INPUT_EXTRA_GIT_CONFIG"

if [ -n "$INPUT_TAG" ] ; then
    git push mirror "$INPUT_TAG" "${CONFIG_FLAGS[@]}"
else
    echo "Not implemented yet"
    exit 1
fi
