#!/bin/bash

cp ~/.config/karabiner-qwerty-old.edn ~/.config/karabiner.edn

osascript ~/dev/osandell/utils-max-of/keyboard-mapping/switch-to-qwerty-old-keyboard-layout.applescript
/usr/local/bin/goku
