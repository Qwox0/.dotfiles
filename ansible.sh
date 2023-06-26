#!/usr/bin/env bash

./ansible/install-ansible

if [ $? -ne 0 ]; then exit $?; fi

./ansible/run.sh dotfiles
