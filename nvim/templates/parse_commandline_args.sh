POSITIONAL_ARGS=()
while [[ $# -gt 0 ]]; do
    case $1 in
        --) shift; POSITIONAL_ARGS+=("$@"); break;;
        -e|--extension)
            EXTENSION="$2"
            shift; shift;;
        -s|--searchpath)
            SEARCHPATH="$2"
            shift; shift;;
        --default)
            DEFAULT=YES
            shift;;
        -*|--*) error "Unknown option $1" 1;;
        *) POSITIONAL_ARGS+=("$1"); shift;;
    esac
done
set -- "${POSITIONAL_ARGS[@]}"
unset POSITIONAL_ARGS
