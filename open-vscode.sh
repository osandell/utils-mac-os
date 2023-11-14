#!/usr/bin/env bash

if [[ -z $1 ]]; then
    # If no argument is provided, open Visual Studio Code in current dir 
    /usr/local/bin/code .
else
    # If an argument is provided, open Visual Studio Code with the specified path
    /usr/local/bin/code $1
fi

osascript ~/dev/osandell/set-window-boundaries/set-window-boundaries.applescript Code primary maximized auto
