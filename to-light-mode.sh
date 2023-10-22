#!/usr/bin/env bash

# Store the name of the current active app
current_app=$(osascript -e 'tell application "System Events" to get the name of the first process whose frontmost is true')

osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to false'

cp ~/.config/kitty/themes/solarized-light.conf ~/.config/kitty/current-theme.conf

osascript -e 'tell application "kitty" to activate'
osascript -e 'tell application "System Events" to keystroke "," using {command down, control down}'

sed -i '' '/"workbench.colorTheme":/c\    
"workbench.colorTheme": "Solarized Light",' ~/.config/Code/User/settings.json

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
if [ "$current_app" == "Electron" ]; then
    osascript -e 'tell application "Visual Studio Code" to activate'
else
    osascript -e "tell application \"$current_app\" to activate"
fi
