#!/bin/bash

cp ~/.config/karabiner-colemak-dh.edn ~/.config/karabiner.edn
osascript ~/dev/osandell/scripts-osx/keyboard-mapping/switch-to-qwerty-keyboard-layout.applescript
/usr/local/bin/goku
