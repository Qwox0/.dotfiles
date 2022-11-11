#!/bin/bash

# ------------------------------
# Path where nvim searches for init.lua
# nvim_config_path="$HOME/.config/nvim"
nvim_config_path="$HOME/.config/nvim"
# ------------------------------

script_path="$(dirname $(readlink -f $0))"		# readlink -f <file>: get full path to <file>
echo "nvim conf path: $nvim_config_path"

echo "link $nvim_config_path -> $script_path"
ln -s "$script_path" "$nvim_config_path"

