#!/usr/bin/env bash

# To prevent auto reload of windows by Mac OS:
# open ~/Library/Preferences/ByHost/com.apple.loginwindow.*.plist with Finder Get Info
# and set it to locked.

# From https://github.com/dflock/kitty-save-session
# Convert this JSON file into a kitty session file:
kitty @ ls | python3 ~/.config/kitty/kitty-convert-dump.py >~/.config/kitty/kitty-session.kitty

open -a "FF Personal"
osascript -e 'tell application "FireFox" to quit'
open -a "FF Work"
osascript -e 'tell application "FireFox" to quit'
open -a "FF YouTube"
osascript -e 'tell application "FireFox" to quit'

osascript -e 'tell app "System Events" to restart'
