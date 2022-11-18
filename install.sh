#!/bin/bash
# args must be config folders like `nvim`

do_relinks=false

script_path="$(dirname $(readlink -f $0))"

print_err() {
    printf "ERR: $@\n"
}
ll_dir() {
    # -d: show directory instead of content
    ls -aldhF --color=auto $@
}

if [[ $# == 0 ]]; then # install all dotfiles
    directories=$(find "$script_path" -maxdepth 1 -type d -not -name "\.*")
else
    directories=$(find "$@" -maxdepth 0 -type d -not -name "\.*" -exec readlink -f {} \;)
fi

if [[ $directories == "" ]]; then exit 1; fi

for config in $directories; do
    printf "\n"
    printf "found config: $config\n"

    target_file="$config/TARGET"
    if [[ ! -f $target_file ]]; then print_err "$target_file is missing!"; continue; fi

    target=""
    source $target_file     # read $target
    if [[ $target == "" ]]; then print_err "cannot read \$target from $target_file"; continue; fi
    printf "found target: $target\n"


    if [[ -L "$target" ]]; then
        printf "$target already exists and is a symbolic link\n"
        ll_dir "$target"
        if $do_relinks; then
            printf "deleting $target\n"
            rm "$target"
        fi
    fi

    if [[ -d "$target" && ! -L "$target" ]]; then
        printf "$target already exists and is a directory\n"
        ll_dir "$target"
        printf "Trying \`rmdir $target\`\n"
        rmdir "$target"
    fi

    if [[ -e "$target" ]]; then
        printf "skipping link creation\n"
    else
        printf "link $target -> $config\n"
        ln -s "$config" "$target"
    fi
done

printf "\n"

