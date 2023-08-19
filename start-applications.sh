#!/bin/bash

osascript -e "tell application \"Noteland\" to activate"
osascript -e "tell application \"kitty\" to activate"
osascript -e "tell application \"GitKraken\" to activate"
osascript -e "tell application \"FF Work\" to activate"
osascript -e "tell application \"FF Personal\" to activate"
osascript -e "tell application \"Visual Studio Code\" to activate"
osascript -e "tell application \"Chrome\" to activate"
osascript -e "tell application \"Slack\" to activate"
osascript -e "tell application \"FF YouTube\" to activate"
osascript -e "tell application \"Chrome\" to activate"
osascript -e "tell application \"kitty\" to activate"

# For some reason this wont work when running through LaunchAgent. I made a workaround by creating the script
# ~/dev/osandell/scripts-osx/move-kitty-window.sh
# that is started through pm2 instead.
#osascript /Users/olof/dev/osandell/set-window-boundaries/set-window-boundaries.applescript kitty primary custom auto 0.428 1 -0.286 0

while true; do
    sleep 60
done
