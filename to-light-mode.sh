#!/usr/bin/env bash

curl -X POST -d "activateLightMode" http://localhost:57321

# Store the name of the current active app
current_app=$(cat /tmp/current_app.txt)

osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'

cp ~/.config/kitty/themes/solarized-light.conf ~/.config/kitty/current-theme.conf

# # From https://github.com/dflock/kitty-save-session
# # Convert this JSON file into a kitty session file:
# socket=$(ls /tmp/mykitty-* 2>/dev/null | head -n 1)
# if [[ -n "$socket" ]]; then
#     export KITTY_LISTEN_ON="unix:$socket"
#     /Applications/kitty.app/Contents/MacOS/kitty @ ls | python3 ~/.config/kitty/kitty-convert-dump.py >~/.config/kitty/kitty-session.kitty
# else
#     echo "No Kitty socket found in /tmp."
# fi

# osascript -e 'tell application "kitty" to quit'
# osascript -e 'tell application "kitty" to activate'

# osascript ~/dev/osandell/set-window-boundaries/set-window-boundaries.applescript kitty primary custom auto 0.406 1 -0.297 0

osascript -e 'tell application "kitty-main" to activate'
osascript -e 'tell application "System Events" to keystroke "," using {command down, control down}'
osascript -e 'tell application "kitty-lf" to activate'
osascript -e 'tell application "System Events" to keystroke "," using {command down, control down}'osascript -e 'tell application "kitty" to activate'
osascript -e 'tell application "System Events" to keystroke "," using {command down, control down}'

awk '/"workbench.colorTheme":/ {print "  \"workbench.colorTheme\": \"Solarized Light\","; next}1' /Users/olof/.config/Code/User/settings.json >/tmp/temp.json && mv /tmp/temp.json /Users/olof/.config/Code/User/settings.json

osascript -e 'tell application "GitKraken" to activate'
osascript -e 'tell application "System Events" to keystroke "p" using {command down}'
osascript -e 'tell application "System Events" to keystroke "theme"'
osascript -e 'tell application "System Events" to key code 36'
osascript -e 'tell application "System Events" to keystroke "solar"'
osascript -e 'tell application "System Events" to key code 36'
osascript -e 'tell application "System Events" to key code 53'
osascript -e 'tell application "System Events" to key code 53'

osascript -e 'tell application "kitty" to activate'

# Check if the current app is Electron-based, if so, activate VSCode, otherwise activate the originally active app
if [ "$current_app" == "coding-environment" ]; then
    open -a "kitty-main"
    curl -X POST localhost:57321 -d "openCurrentApp"
else
    osascript -e "tell application \"$current_app\" to activate"
fi
