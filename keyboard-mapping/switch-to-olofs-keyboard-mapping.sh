#!/bin/bash

osascript ~/dev/osandell/utils-max-of/keyboard-mapping/switch-to-olofs-keyboard-layout.applescript
/Library/Application\ Support/org.pqrs/Karabiner-Elements/bin/karabiner_cli --select-profile 'Default'
osascript -e 'tell application "Code" to activate'
osascript -e 'delay 1'
osascript -e 'tell application "System Events" to keystroke "v" using {shift down, control down}'
mv .config/karabiner/karabiner.json.bak .config/karabiner/karabiner.json
