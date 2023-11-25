#!/usr/bin/env bash

ansible_path=${0%/*}

local_yml="$ansible_path/local.yml"

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
        ?)
            echo "script usage: $(basename $0) [opt] tag" >&2
            echo "[opt]:"
            echo "  -K, -p, -r, -s: ask for BECOME password (default)"
            echo "  -n, -u        : try to run script without BECOME password"
            exit 1
            ;;
    esac
done
shift "$(($OPTIND -1))"

tags_str="$(ansible-playbook local.yml --list-tags 2>/dev/null | grep "TASK TAGS:" | sed "s/^\s*TASK TAGS: \[\(.*\)\]$/\1/")"
IFS=', ' read -r -a tags <<< "$tags_str"

tag="$1"

IFS=$'\n'
if [ -z "$(echo "${tags[*]}" | grep "^$tag$")" ]; then
    echo "please provide tag!"
    echo "the following tags are available:"
    printf '    * `%s`\n' "${tags[@]}"
    echo -e "\nIf you want to run all tasks use \`ansible-playbook $local_yml\`"
    exit 2
fi
unset IFS

if ! $ask_pw; then
    ansible-playbook $local_yml -t $tag

    if [ $? == 0 ]; then
        echo "finished running ansible playbook. :)"
        exit 0
    fi

    echo "failed to run ansible playbook. :("
    echo -n "run with -K flag? [Y/q] : "
    read -r input # -r: prevent \ escaping (e.g for multiple lines)

    if [[ $input != "" && $input != "y" && $input != "Y" ]]; then exit 3; fi
fi

ansible-playbook $local_yml -K -t $tag

if [ $? == 0 ]; then
    echo "finished running ansible playbook. :)"
    exit 0
else
    echo "failed to run ansible playbook. :("
    exit 3
fi
