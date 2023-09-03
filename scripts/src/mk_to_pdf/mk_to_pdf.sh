#!/usr/bin/env bash

script="$(readlink -f $0)"
script_path="$(dirname $script)"

compiler="pandoc"
install_cmd="sudo apt install pandoc wkhtmltopdf"

if ! type "$compiler" > /dev/null; then
    echo "\`$compiler\` command not found." >&2
    echo "This script requires the \`$compiler\` compiler" >&2
    echo "hint: use \`$install_cmd\`" >&2
    exit 1
fi

in_file="$1"

if [ -z $in_file ]; then
    echo "please provide a markdown file" >&2
    exit 2
fi

in_file_name="${in_file%.*}"

css_file="$script_path/github.css"

# $compiler -f gfm -t html5 \
#     --metadata pagetitle="${in_file##*/}" \
#     --pdf-engine-opt=--enable-local-file-access \
#     --css $css_file \
#     $in_file \
#     -o "$in_file_name.pdf"

pandoc -f markdown+pipe_tables -t html5 --metadata pagetitle="${in_file##*/}" $in_file -o "$in_file_name.pdf"
