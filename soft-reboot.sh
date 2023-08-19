#!/usr/bin/env bash

# To prevent auto reload of windows by Mac OS:
# open ~/Library/Preferences/ByHost/com.apple.loginwindow.*.plist with Finder Get Info
# and set it to locked.

~/.config/kitty/save_kitty_session.sh
osascript -e 'tell app "System Events" to restart'
