#!/usr/bin/env bash

set -e

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

# usage: arr_contains arr_name value
arr_contains() {
    arr_name="$1[@]"
    for x in ${!arr_name}; do
        if [ $x == $2 ]; then return 0; fi
    done
    return 1
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

tags_str="$($ansible_playbook_cmd $local_yml --list-tags 2>/dev/null | grep "TASK TAGS:" | sed "s/^\s*TASK TAGS: \[\(.*\)\]$/\1/")"
all_tags=( $(tr -d "," <<< "$tags_str") )

selected_tags=( $(tr "," " " <<< $@) )

tag_err() {
    echo "$all_tags"
    tag_list_fancy="$(printf '    * `%s`\n' "${all_tags[@]}")"
    err="$1
the following tags are available:
${tag_list_fancy}

If you want to run all tasks use \`ansible-playbook $local_yml\`
"
    error "$err" $2
}

if [ -z "$selected_tags" ]; then tag_err "please provide tag!" 2; fi

for tag in ${selected_tags[@]}; do
    if ! arr_contains all_tags $tag; then tag_err "unknown tag '$tag'" 3; fi
done

declare -p selected_tags

comma_seperated_tags="$(tr " " "," <<< "${selected_tags[@]}")"

if ! $ask_pw; then
    (set -x
    $ansible_playbook_cmd $local_yml -t $comma_seperated_tags)

    if [ $? == 0 ]; then
        info "finished running ansible playbook. :)"
        exit 0
    fi

    echo "failed to run ansible playbook. :("
    echo -n "run with -K flag? [Y/q] : "
    read -r input # -r: prevent \ escaping (e.g for multiple lines)

    if [[ $input != "" && $input != "y" && $input != "Y" ]]; then exit 3; fi
fi

(set -x
$ansible_playbook_cmd $local_yml -K -t $comma_seperated_tags)

if [ $? == 0 ]; then
    info "finished running ansible playbook. :)"
else
    error "failed to run ansible playbook. :(" 4
fi
