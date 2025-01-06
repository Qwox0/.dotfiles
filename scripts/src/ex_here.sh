#!/usr/bin/env bash
# usage: ex <file>

set -e

error() {
    echo -e "\e[91;1m+++ ERROR:\e[0m $1" >&2
    exit $2
}

if [ ! -f "$1" ] ; then
    error "'$1' is not a valid file" 1
fi

case $1 in
    *.tar.bz2)   tar xjf $1   ;;
    *.tar.gz)    tar xzf $1   ;;
    *.bz2)       bunzip2 $1   ;;
    *.rar)       unrar x $1   ;;
    *.gz)        gunzip $1    ;;
    *.tar)       tar xf $1    ;;
    *.tbz2)      tar xjf $1   ;;
    *.tgz)       tar xzf $1   ;;
    *.zip)       unzip $1     ;;
    *.Z)         uncompress $1;;
    *.7z)        7z x $1      ;;
    *.deb)       ar x $1      ;;
    *.tar.xz)    tar xf $1    ;;
    *.tar.zst)   unzstd $1    ;;
    *.zst)       unzstd $1    ;;
    *.zpaq)      zpaq x $1    ;;
    *)           error "\"$1\" cannot be extracted via ex()" 2 ;;
esac
