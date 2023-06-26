#!/usr/bin/env bash


dotfiles_path=${0%/*}

$dotfiles_path/ansible/install-ansible

if [ $? -ne 0 ]; then exit $?; fi

$dotfiles_path/ansible/run.sh -K dotfiles
