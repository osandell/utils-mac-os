#!/bin/bash

cd $(dirname "$0")

if [ "$1" = "Screen password unlocked" ]; then
  killall LogiMgrDaemon
  ./sync-git-repos.sh
elif [ "$1" = "Screen password locked" ]; then
  ./check-repos-are-pushed.sh
# elif [ "$1" = "Screen was added" ]; then
#   ./position-all-windows.sh
# elif [ "$1" = "Screen was removed" ]; then
#   ./position-all-windows.sh
fi
