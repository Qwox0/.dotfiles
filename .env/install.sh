#!/usr/bin/env bash

echo $0
find . -regex "\./[^\.]*$" -exec echo {} \;
