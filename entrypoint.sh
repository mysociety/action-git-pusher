#!/usr/bin/env bash

set -e

eval "$(ssh-agent)"
ssh-add <(echo "$INPUT_GIT_SSH_KEY")

if [ -n "$INPUT_SSH_KNOWN_HOSTS" ] ; then
    echo "$INPUT_SSH_KNOWN_HOSTS" > /known_hosts
    git config --global core.sshCommand "ssh -o UserKnownHostsFile=/known_hosts -o CheckHostIP=no"
else
    git config --global core.sshCommand "ssh -o StrictHostKeyChecking=no -o CheckHostIP=no"
fi

git remote add mirror "$INPUT_REMOTE"

if [ -n "$INPUT_TAG" ] ; then
    git push mirror "$INPUT_TAG"
else
    echo "Not implemented yet"
    exit 1
fi
