#!/usr/bin/env bash

# Specify the socket to communicate with Kitty
socket=unix:/tmp/kitty_main

while true; do
    sleep 1 # Check every second

    # Get the ID of the active window
    active_window_id=$(kitty @ --to=$socket ls | jq -r '.[].tabs[] | select(.is_focused) | .windows[] | select(.is_focused).id')

    # Get the process running in the active window and filter out the script and utilities
    if [[ -n "$active_window_id" ]]; then
        process_info=$(kitty @ --to=$socket ls | jq -r ".[].tabs[].windows[] | select(.id == $active_window_id).foreground_processes[] | select(.cmdline[0] != \"bash\" and .cmdline[0] != \"jq\" and .cmdline[0] != \"kitten\")")

        # Check if the output contains Vim's command line
        if echo "$process_info" | grep -qE '/Users/olof/.nix-profile/bin/vim|/Users/olof/.nix-profile/bin/nvim'; then
            echo "vim" >/tmp/current_active_kitty_proc
        else
            echo "other" >/tmp/current_active_kitty_proc
        fi
    else
        echo "No active window found in Kitty." >/tmp/current_active_kitty_proc
    fi
done
