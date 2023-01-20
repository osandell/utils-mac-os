#!/bin/bash

osascript -e "say \"$1\""

if [ "$1" = "Screen password unlocked" ]; then
  killall LogiMgrDaemon
  ./sync_git_repos.sh
elif [ "$1" = "Screen password locked" ]; then
  ./check_repos_are_pushed.sh
elif [ "$1" = "Screen was added" ]; then
  ./position_all_windows.sh
elif [ "$1" = "Screen was removed" ]; then
  ./position_all_windows.sh
fi
