#!/usr/bin/env bash

info() {
    echo -e "\e[92;1m+++\e[0m $1"
}

warn() {
    echo -e "\e[93;1m+++ WARN:\e[0m $1"
}

error() {
    echo -e "\e[91;1m+++ ERROR:\e[0m $1" >&2
    exit $2
}

ansible_path=${0%/*}

local_yml="$ansible_path/local.yml"

ansible_playbook_cmd="ansible-playbook"

if [ ! $(which "$ansible_playbook_cmd") ]; then
    warn "Couldn't find \`ansible-playbook\` in PATH. using default"
    ansible_playbook_cmd="$HOME/.local/bin/ansible-playbook"
fi

__usage="
Usage: $(basename $0) [OPTIONS] tag

Options:
  -K, -p, -r, -s            ask for BECOME password (default)
  -n, -u                    try to run script without BECOME password
"

# BECOME password
ask_pw=true
while getopts "Kprsnu" OPTION; do
    case "$OPTION" in
        K) ask_pw=true ;;
        p) ask_pw=true ;;
        r) ask_pw=true ;;
        s) ask_pw=true ;;
        n) ask_pw=false ;;
        u) ask_pw=false ;;
        ?) error "$__usage" 1 ;;
    esac
done
shift "$(($OPTIND -1))"

tags_str="$($ansible_playbook_cmd $local_yml --list-tags | grep "TASK TAGS:" | sed "s/^\s*TASK TAGS: \[\(.*\)\]$/\1/")"
IFS=', ' read -r -a tags <<< "$tags_str"

tag="$1"

IFS=$'\n'
if [ -z "$(echo "${tags[*]}" | grep "^$tag$")" ]; then
    tag_list_fancy="$(printf '    * `%s`\n' "${tags[@]}")"
    err="please provide tag!
the following tags are available:
${tag_list_fancy}

If you want to run all tasks use \`ansible-playbook $local_yml\`
"
    error "$err" 2
fi
unset IFS

if ! $ask_pw; then
    $ansible_playbook_cmd $local_yml -t $tag

    if [ $? == 0 ]; then
        info "finished running ansible playbook. :)"
        exit 0
    fi

    echo "failed to run ansible playbook. :("
    echo -n "run with -K flag? [Y/q] : "
    read -r input # -r: prevent \ escaping (e.g for multiple lines)

    if [[ $input != "" && $input != "y" && $input != "Y" ]]; then exit 3; fi
fi

$ansible_playbook_cmd $local_yml -K -t $tag

if [ $? == 0 ]; then
    info "finished running ansible playbook. :)"
else
    error "failed to run ansible playbook. :(" 3
fi
