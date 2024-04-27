#!/usr/bin/env bash

script_dir="$(dirname "$0")"

info() {
    echo -e "\e[92;1m+++\e[0m $1"
}

error() {
    echo -e "\e[91;1m+++ ERROR:\e[0m $1" >&2
    exit $2
}

dir_path="$1"
zip_path="$(basename "$dir_path").zip"

info "$dir_path"

if [[ ! -d "$dir_path" ]]; then
    error "Please provide the path to a valid directory"
fi

info "compressing $dir_path -> $zip_path"
zip -r "$zip_path" "$dir_path"
