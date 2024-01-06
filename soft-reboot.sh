#!/usr/bin/env bash

# To prevent auto reload of windows by Mac OS:
# open ~/Library/Preferences/ByHost/com.apple.loginwindow.*.plist with Finder Get Info
# and set it to locked.

# From https://github.com/dflock/kitty-save-session
# Convert this JSON file into a kitty session file:
echo "Looking for Kitty socket in /tmp..."
socket=$(ls /tmp/mykitty-* 2>/dev/null | head -n 1)
if [[ -n "$socket" ]]; then
    echo "Found Kitty socket in $socket."
    export KITTY_LISTEN_ON="unix:$socket"
    # Here we could simply do kitty @ ls | python3 ~/.config/kitty/kitty-convert-dump.py >~/.config/kitty/kitty-session.kitty
    # but I use a method that will also work if invoked form outside of kitty for future reference.
    /Applications/kitty.app/Contents/MacOS/kitty @ ls | python3 ~/.config/kitty/kitty-convert-dump.py >~/.config/kitty/kitty-session.kitty
else
    echo "No Kitty socket found in /tmp."
fi

# From https://github.com/dflock/kitty-save-session
# Convert this JSON file into a kitty session file:
echo "Dumping Kitty session..."
kitty @ ls | python3 ~/.config/kitty/kitty-convert-dump.py >~/.config/kitty/kitty-session.kitty

echo "Closing FF Personal..."
open -a "FF Personal"
osascript -e 'tell application "FireFox" to quit'
echo "Closing FF Work..."
open -a "FF Work"
osascript -e 'tell application "FireFox" to quit'
open -a "FF Work"
open -a "FF YouTube"
osascript -e 'tell application "FireFox" to quit'

echo "Issuing soft reboot..."
osascript -e 'tell app "System Events" to restart'
