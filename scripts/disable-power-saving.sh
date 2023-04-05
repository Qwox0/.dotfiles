#!/usr/bin/env bash


output=true
case $1 in
    -n|-np|-no|-no-print|-no-output) output=false;;
esac

print_info() {
    section_content='\(\s\+[^\n]*\n\)*'
    xset q | sed -z "s;.*\(Screen Saver:\n$section_content\).*\(DPMS (Energy Star):\n$section_content\);\1\3;"
}

[ "$output" == true ] &&
    echo "old:" &&
    print_info

xset -dpms
xset s off

[ "$output" == true ] &&
    echo -e "\nnew:" &&
    print_info
