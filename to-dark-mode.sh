!/usr/bin/env bash

curl -X POST -d "activateDarkMode" http://localhost:57321

# Store the name of the current active app
focused_global_app=$(cat /tmp/focused_global_app.txt)

osascript -e 'tell application "System Events" to tell appearance preferences to set dark mode to true'

# Kitty
cp ~/.config/kitty/themes/gruvbox.conf ~/.config/kitty/current-theme.conf
open -a 'Electron'
open -a 'kitty-main'
sleep 0.2
open -a 'kitty-main'
osascript -e 'tell application "System Events" to keystroke "," using {command down, control down}'
osascript -e 'tell application "kitty-lf" to activate'
osascript -e 'tell application "System Events" to keystroke "," using {command down, control down}'

# Git diff
new_delta_config="[delta]
syntax-theme = \"gruvbox-dark\"
light = false
line-numbers = true
line-numbers-left-format = \"{nm:>3}│\"
line-numbers-minus-style = \"#cc241d\"
line-numbers-right-format = \"{np:>3}│\"
navigate = false
side-by-side = false
true-color = auto
zero-style = \"syntax\""

# Overwrite the ~/.gitconfig_delta file with the new configuration
echo "$new_delta_config" >~/.gitconfig_delta

# # VSCode
# awk '/"workbench.colorTheme":/ {print "  \"workbench.colorTheme\": \"Gruvbox Dark Medium\","; next}1' /Users/olof/.config/Code/User/settings.json >/tmp/temp.json && mv /tmp/temp.json /Users/olof/.config/Code/User/settings.json
# # For some reason the above command doesn't work for the "olof" workspace, so I need to use a local settings.json for that workspace
# awk '/"workbench.colorTheme":/ {print "  \"workbench.colorTheme\": \"Gruvbox Dark Medium\","; next}1' /Users/olof/.vscode/settings.json >/tmp/temp.json && mv /tmp/temp.json /Users/olof/.vscode/settings.json
# Cursor
awk '/"workbench.colorTheme":/ {print "  \"workbench.colorTheme\": \"Gruvbox Dark Medium\","; next}1' /Users/olof/.config/Code/User/settings.json >/tmp/temp.json && mv /tmp/temp.json /Users/olof/.config/Code/User/settings.json
# For some reason the above command doesn't work for the "olof" workspace, so I need to use a local settings.json for that workspace
awk '/"workbench.colorTheme":/ {print "  \"workbench.colorTheme\": \"Gruvbox Dark Medium\","; next}1' /Users/olof/.vscode/settings.json >/tmp/temp.json && mv /tmp/temp.json /Users/olof/.vscode/settings.json

# GitKraken
osascript -e 'tell application "GitKraken" to activate'
osascript -e 'tell application "System Events" to keystroke "p" using {command down}'
osascript -e 'tell application "System Events" to keystroke "theme"'
osascript -e 'tell application "System Events" to key code 36'
osascript -e 'tell application "System Events" to keystroke "gruv"'
osascript -e 'tell application "System Events" to key code 36'
osascript -e 'tell application "System Events" to key code 53'
osascript -e 'tell application "System Events" to key code 53'

# Check if the current app is kitty-main or vscode, if so, activate VSCode, otherwise activate the originally active app
if [ "$focused_global_app" == "kitty-main" ]; then
    open -a 'Electron'
    open -a 'Cursor'
    open -a 'kitty-main'
    sleep 0.2
    open -a 'kitty-main'
elif [ "$focused_global_app" == "vscode" ]; then
    open -a 'Electron'
    open -a 'kitty-main'
    open -a 'Cursor'
    sleep 0.2
    open -a 'Cursor'
else
    osascript -e "tell application \"$focused_global_app\" to activate"
fi
