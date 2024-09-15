#!/usr/bin/env bash

script="$(readlink -f $0)"
script_dir="$(dirname $script)"

# ---------------------------------

print_usage() {
    echo "USAGE: md_to_pdf [OPTIONS] [MD FILE]"
    echo "  -h, -?, --help              Show this help message"
    echo ""
    echo "  --style=github [default]    Use GitHub Flavored Markdown Spec"
    echo "  --style=pandoc              Use Default Pandoc Styling"
}

github_style="--standalone --css $script_dir/github.css"
pandoc_style=""
style="$github_style"

for i in "$@"; do
    case $i in
        -h|-?|--help)
            print_usage
            exit 0
            ;;
        # --style=*)
        #     style="${i#*=}"
        #     shift
        #     ;;
        --style=github)
            style="$github_style"
            shift
            ;;
        --style=pandoc)
            style="$pandoc_style"
            shift
            ;;
        -*|--*)
            echo "Unknown option $i"
            print_usage
            exit 1
            ;;
        *)
            ;;
    esac
done

in_file="$1"

if [ -z "$in_file" ]; then
    echo "please provide a markdown file" >&2
    exit 2
fi

# ---------------------------------

compiler="pandoc"
install_cmd="sudo apt install pandoc weasyprint"

if ! type "$compiler" > /dev/null; then
    echo "\`$compiler\` command not found." >&2
    echo "This script requires the \`$compiler\` compiler" >&2
    echo "hint: use \`$install_cmd\`" >&2
    exit 1
fi

name="${in_file%.*}"

for ext in "html" "pdf"; do
    echo "Generate $ext"

    pandoc -f markdown+pipe_tables -t html5 \
        --pdf-engine=weasyprint \
        --metadata pagetitle="${in_file##*/}" \
        --mathml \
        $style \
        "$in_file" \
        -o "${name}.$ext"
        #--pdf-engine-opt=--enable-local-file-access \
done
