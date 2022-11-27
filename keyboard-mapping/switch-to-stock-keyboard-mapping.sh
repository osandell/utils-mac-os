#!/bin/bash

cp .config/karabiner/karabiner.json .config/karabiner/karabiner.json.bak
 osascript ~/dev/osandell/scripts-osx/keyboard-mapping/switch-to-stock-keyboard-layout.applescript
 /Library/Application\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --select-profile 'Original'
osascript -e 'tell application "Code" to activate'
osascript -e 'delay 1'
osascript -e 'tell application "System Events" to keystroke "v" using {shift down, control down}'
