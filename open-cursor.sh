#!/usr/bin/env bash

if [[ -z $1 ]]; then
    # If no argument is provided, open Visual Studio Code in current dir
    open -a Cursor .
else
    # If an argument is provided, open Visual Studio Code with the specified path
    open -a Cursor $1
fi

# osascript ~/dev/osandell/set-window-boundaries/set-window-boundaries.applescript Code primary maximized auto
