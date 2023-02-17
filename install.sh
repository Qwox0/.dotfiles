#!/bin/env bash

install_playbook() {
    echo "ansible playbook \"$1\" exists"
    echo "running \"ansible-playbook -K -t dotfiles $1\""
    ansible-playbook -K -t dotfiles "$1"
}

if ! command -v ansible-playbook > /dev/null; then
    echo "ansible-playbook is missing!"
    exit 1
fi

if [ -f "$1" ]; then
    install_playbook "$1"
else
    default_ansible_path="$HOME/ansible/local.yml"
    if [ -e "$default_ansible_path" ]; then
        install_playbook "$default_ansible_path"
    else
        echo "\"$1\" nor \"$default_ansible_path\" (default) exist!"
        echo "Please provide an ansible playbook!"
        exit 1
    fi
fi

