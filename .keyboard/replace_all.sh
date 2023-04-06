#!/usr/bin/env bash

if [[ $1 == "" ]]; then echo "enter some \$1"; exit 1; fi

[ -e $1 ] || { echo "enter a valid file for \$1!"; exit 2; }

cp "$1" "$1.bak"

while read l; do
    txt="${l% *}"
    new="${l#* }"
    echo "sed -i.old -e \"s/$txt/$new/g\" $1"
    sed -i -e "s/$txt/$new/g" $1
done<./changes
