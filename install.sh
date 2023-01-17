#!/bin/bash
# args must be config folders like `nvim`

########## Config
do_relinks=false

script_path="$(dirname $(readlink -f $0))"

########## Functions
print() {
    ident=""
    for (( c=0; c<$1; ++c)); do
        ident+=" "
    done
    #echo "$ident${@:2}"
    printf "$ident${@:2}"
}

ll_dir() {
    # -d: show directory instead of content
    print 4 "ls: "
    ls -aldhF --color=auto $@
}

########## Main
if [[ $# == 0 ]]; then # install all dotfiles
    directories=$(find "$script_path" -maxdepth 1 -type d -not -name "\.*")
else # install given dirs
    directories=$(find "$@" -maxdepth 0 -type d -not -name "\.*" -exec readlink -f {} \;)
fi

for config_path in $directories; do
    name=$(basename "$config_path")
    name=${name^^}

    print 0 "\n$name:\n"
    print 4 "Found config: $config_path\n"

    target_file="$config_path/TARGET"
    if [[ ! -f $target_file ]]; then print 4 "ERR: $target_file is missing!\n"; continue; fi

    target=$(source $target_file)
    if [[ $target == "" ]]; then print 4 "ERR: cannot read \$target from $target_file\n"; continue; fi
    print 4 "Found target: $target\n"

    if [[ -L "$target" ]]; then
        print 0 "\n"
        print 4 "\"$target\" already exists and is a symbolic link.\n"
        ll_dir "$target"
        old_link_target=$(readlink -f "$target")
        if [[ $old_link_target != $config_path ]]; then
            print 4 "Incorrect link target!\n"
            print 4 "Deleting link: \`rm $target\`\n"
            rm "$target"
        fi
    elif [[ -d "$target" ]]; then
        print 0 "\n"
        print 4 "$target already exists and is a directory.\n"
        ll_dir "$target"
        print 4 "Deleting directory if empty: \`rmdir $target\`\n"
        rmdir "$target"
    fi

    if [[ -e "$target" ]]; then
        print 5 "=> Skipping link creation\n\n"
    else
        print 5 "=> Linking \"$target\" -> \"$config_path\"\n\n"
        ln -s "$config_path" "$target"
    fi
done
