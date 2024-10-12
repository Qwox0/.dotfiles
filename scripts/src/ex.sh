#!/usr/bin/env bash

script_dir="$(dirname "$0")"

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

archive_file="$1"
archive_file_full_path="$(realpath "$archive_file")"
archive_name="${archive_file##*/}"
dir_name="${archive_file%.*}"

if [ ! -f "$archive_file" ]; then
    error "Please provide an archive file as the first argument!" 1
fi

if [ -e "$dir_name" ]; then
    error "\"${dir_name}\" exists already!" 2
fi

info "creating directory \"$dir_name\""
mkdir "$dir_name"

info "moving archive: \"$archive_file\" -> \"$dir_name/$archive_name\""
mv "$archive_file" "$dir_name"

cd "$dir_name"

info "extracting archive \"$archive_name\" in \"$dir_name\""
"$script_dir/ex_here" "$archive_name"

info "moving archive back: \"$dir_name/$archive_name\" -> \"$archive_file_full_path\""
mv "$archive_name" "$archive_file_full_path"
