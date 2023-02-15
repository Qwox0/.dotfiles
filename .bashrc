# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# If not running interactively, don't do anything
case $- in
    *i*) ;;
      *) return;;
esac

# don't put duplicate lines or lines starting with space in the history.
# See bash(1) for more options
HISTCONTROL=ignoreboth

# append to the history file, don't overwrite it
shopt -s histappend

# for setting history length see HISTSIZE and HISTFILESIZE in bash(1)
HISTSIZE=1000
HISTFILESIZE=2000

# check the window size after each command and, if necessary,
# update the values of LINES and COLUMNS.
shopt -s checkwinsize

# If set, the pattern "**" used in a pathname expansion context will
# match all files and zero or more directories and subdirectories.
#shopt -s globstar

# make less more friendly for non-text input files, see lesspipe(1)
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

# set variable identifying the chroot you work in (used in the prompt below)
if [ -z "${debian_chroot:-}" ] && [ -r /etc/debian_chroot ]; then
    debian_chroot=$(cat /etc/debian_chroot)
fi

# set a fancy prompt (non-color, unless we know we "want" color)
case "$TERM" in
    xterm-color|*-256color) color_prompt=yes;;
esac

# uncomment for a colored prompt, if the terminal has the capability; turned
# off by default to not distract the user: the focus in a terminal window
# should be on the output of commands, not on the prompt
#force_color_prompt=yes

if [ -n "$force_color_prompt" ]; then
    if [ -x /usr/bin/tput ] && tput setaf 1 >&/dev/null; then
	# We have color support; assume it's compliant with Ecma-48
	# (ISO/IEC-6429). (Lack of such support is extremely rare, and such
	# a case would tend to support setf rather than setaf.)
	color_prompt=yes
    else
	color_prompt=
    fi
fi

if [ "$color_prompt" = yes ]; then
    PS1='${debian_chroot:+($debian_chroot)}\[\033[01;32m\]\u@\h\[\033[00m\]:\[\033[01;34m\]\w\[\033[00m\]\$ '
else
    PS1='${debian_chroot:+($debian_chroot)}\u@\h:\w\$ '
fi
unset color_prompt force_color_prompt

# If this is an xterm set the title to user@host:dir
case "$TERM" in
xterm*|rxvt*)
    PS1="\[\e]0;${debian_chroot:+($debian_chroot)}\u@\h: \w\a\]$PS1"
    ;;
*)
    ;;
esac

# enable color support of ls and also add handy aliases
if [ -x /usr/bin/dircolors ]; then
    test -r ~/.dircolors && eval "$(dircolors -b ~/.dircolors)" || eval "$(dircolors -b)"
    alias ls='ls --color=auto'
    #alias dir='dir --color=auto'
    #alias vdir='vdir --color=auto'

    alias grep='grep --color=auto'
    alias fgrep='fgrep --color=auto'
    alias egrep='egrep --color=auto'
fi

# colored GCC warnings and errors
#export GCC_COLORS='error=01;31:warning=01;35:note=01;36:caret=01;32:locus=01:quote=01'

# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

alias v='nvim'
alias vi='nvim'
alias vim='nvim'

alias ls='ls -hF --color=auto'

alias ks='ls' # prevent misstypes

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

# enable programmable completion features (you don't need to enable
# this, if it's already enabled in /etc/bash.bashrc and /etc/profile
# sources /etc/bash.bashrc).
if ! shopt -oq posix; then
  if [ -f /usr/share/bash-completion/bash_completion ]; then
    . /usr/share/bash-completion/bash_completion
  elif [ -f /etc/bash_completion ]; then
    . /etc/bash_completion
  fi
fi

# default editor
export EDITOR='nvim'

### Rust programming language home path
### default values:
# export RUSTUP_HOME=/home/qwox/.rustup
# export CARGO_HOME=/home/qwox/.cargo
#. "$HOME/.cargo/env" # see ~/.dotfiles/.bash_path

# . "$HOME/.dotfiles/.bash_path"

add_to_path() {
    path="$1"
    #echo "add: $path"
    # affix colons on either side of $PATH to simplify matching
    case ":${PATH}:" in
        *:"$path":*)
            # already in path
            ;;
        *)
            export PATH="$path:$PATH"
            ;;
    esac
}

add_to_path "$HOME/bin" # already exists in PATH. why?
add_to_path "$HOME/.local/bin"
add_to_path "$HOME/.cargo/bin" # already exists in PATH. why?

if command -v starship > /dev/null; then
    eval "$(starship init bash)"
fi