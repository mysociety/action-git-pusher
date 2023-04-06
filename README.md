# Git Mirroring Action

**This is being tested, and is subject to change**

This simple action can be used to push git objects to a secondary
repository.

There are other actions out there that do similar things, but none that
quite meet our use-case.

Currently, this only supports pushing tags - trying to run this action
without providing a `tag` input will generate an error.

As an example where this is being used with a tagging action where you
want to ensure the tag is pushed to another remote:

```yaml
name: Bump Tag
on:
  push:
    branches:
      - master

jobs:
  build:
    runs-on: ubuntu-latest
    steps:

    - name: Checkout
    - uses: actions/checkout@v2
      with:
        fetch-depth: '0'

    - name: Bump tag
      id: bump_tag
      uses: anothrNick/github-tag-action@master
      env:
        GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
        WITH_V: true

    - name: Push Tag to mirror
      id: push_to_mirror
      uses: mysociety/action-git-pusher@v1.0.0
      with:
        git_ssh_key: ${{ secrets.SOME_GIT_KEY }}
        ssh_known_hosts: ${{ secrets.SOME_KNOWN_HOSTS }}
        tag: ${{ steps.bump_tag.outputs.new_tag }}
        remote: 'ssh://username@git.example.com/path/to/repository.git'
```

To add extra flags to the git push command, you can use the `extra_git_config` input.

```yaml
    - name: Test force pushing to mirror
      id: push_to_mirror
      uses: mysociety/action-git-pusher@v1.0.0
      with:
        git_ssh_key: ${{ secrets.SOME_GIT_KEY }}
        ssh_known_hosts: ${{ secrets.SOME_KNOWN_HOSTS }}
        tag: ${{ steps.bump_tag.outputs.new_tag }}
        remote: 'ssh://username@git.example.com/path/to/repository.git'
        extra_git_config: --force --dry-run
```