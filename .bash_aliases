# extention of ~./bashrc

# ~/.bash_profile is invoked on bash start
# bash reads and executes commands from ~/.bashrc

#############################
##### own aliases

### Neovim
alias v='nvim'
alias vi='nvim'
alias vim='nvim'


# \<cmd> uses original

### list (ls) ###
alias ls='ls -hF --color=auto'
# always show human-readable file sizes

# prevent misstypes
alias ks='ls'


#############################
##### bash functions

### disk usage ###
du() {
    arg="$1"
    if [[ $arg == /* ]]; then
        find "$1" -maxdepth 1 -exec du -sh {} \; | sort -h
    else
        find "./$1" -maxdepth 1 -exec du -sh {} \; | sort -h
    fi
}
# old :
#alias du='find . -maxdepth 1 -exec du -sh {} \; | sort -h'
#alias du='du -shc {.[!.]*,..?*,*} | sort -h'
# {.[!.]*,..?*,*} = everything in current directory (with hidden dirs and spaces in name allowed)


### quick cd
cd() {
    args="$@"
    # cd ..N -> go back N repositories
    if [[ $args == ".."[0-9] ]]; then
        num=${args:2}
        back=""
        for ((i=0; i<$num; i++)); do back+="../"; done
        cd "$back"
        echo "pwd: $PWD"
    # cd ~q/[o] -> /home/qwox/[o]
    elif [[ $args =~ ^~q ]]; then
        o=${args:2}
        cd "/home/qwox$o"
        echo "pwd: $PWD"
    else
        command cd "$@"
    fi
}
# hint: reg exp needs =~
# ex: $@ =~ ^..[0-9]{1,2}$
# ^[0-9]+$: reg Exp for any pos int
# ^[0-9]{1,2}$: reg Exp for one or two digit number
# ^: start of line
# $: end of line
# +: one or more
# {1,2}: one or two times


xpropclass() {
    xprop=$(xprop WM_CLASS)
    echo "$xprop"

    #regex='"([^"]*)",[[:space:]]"([^"]*)"'
    #[[ $xprop =~ $regex ]] && res=( "${BASH_REMATCH[1]} ${BASH_REMATCH[2]}" )

    res=$(echo "$xprop" | sed -r 's/WM_CLASS\(STRING\) = "(.*)", "(.*)"/\1 \2/g')
    arr=( $res )
    echo "Instance: \"${arr[0]}\""
    echo "Class: \"${arr[1]}\""
}
