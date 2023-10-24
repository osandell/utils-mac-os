#!/bin/bash

while true; do
    # Check if Visual Studio Code has any visible windows
    result=$(osascript -e '
        tell application "System Events" to tell process "Electron"
            if number of windows > 0 then
                return "true"
            else
                return "false"
            end if
        end tell
    ')

    # Write the result to a file in /tmp/
    echo $result > /tmp/vscode_has_open_windows.txt

    # Sleep for 1 second before checking again
    sleep 1
done
