#!/usr/bin/env bash

set -e

script_dir="$(dirname "$0")"

info() {
    echo -e "\e[92;1m+++\e[0m $1"
}

warn() {
    echo -e "\e[93;1m+++ WARN:\e[0m $1"
}

error() {
    echo -e "\e[91;1m+++ ERROR:\e[0m $1" >&2
    if [ $2 -ne 0 ]; then exit $2; fi
}

# `--progress` is needed, otherwise git hides it's output
clone_output="$(git clone --no-checkout --progress "$@" 2>&1 | tee /dev/tty)"

project_dir="$(echo "$clone_output" | head -1 | sed "s/Cloning into '\(.*\)'\.\.\./\1/")"

info "cd $project_dir"
cd "$project_dir"

first_commit="$(git log --reverse --pretty=oneline | head -1 | cut -d ' ' -f 1)"
info "checking out first commit: $first_commit"
git checkout --detach "$first_commit"

info "deleting all files"
git read-tree -u --reset $(git hash-object -t tree /dev/null)

master_branch="$(git remote show $(git remote show) | sed -n '/HEAD branch/s/.*: //p')"

info "adding \"$master_branch\" worktree"
git worktree add "$master_branch" "$master_branch"
