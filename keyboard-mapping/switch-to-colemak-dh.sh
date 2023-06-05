#!/bin/bash

cp ~/.config/karabiner-colemak-dh.edn ~/.config/karabiner.edn

osascript ~/dev/osandell/scripts-osx/keyboard-mapping/switch-to-colemak-dh-keyboard-layout.applescript
/usr/local/bin/goku
