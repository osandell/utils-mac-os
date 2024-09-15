#!/usr/bin/env bash

if [[ -z $1 ]]; then
    # If no argument is provided, open Cursor in current dir
    open -a Cursor .
else
    # If an argument is provided, check if it's a file
    if [[ -f $1 ]]; then
        # If file exists, open it with Cursor
        open -a Cursor "$1"
    else
        # If file doesn't exist, create it and then open with Cursor
        touch "$1"
        open -a Cursor "$1"
    fi
fi
