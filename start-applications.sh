#!/bin/bash

osascript -e "tell application \"Noteland\" to activate"
osascript -e "tell application \"TablePlus\" to activate"
osascript -e "tell application \"GitKraken\" to activate"
osascript -e "tell application \"FF Work\" to activate"
osascript -e "tell application \"FF Personal\" to activate"
osascript -e "tell application \"FF YouTube\" to activate"
osascript -e "tell application \"Visual Studio Code\" to activate"
osascript -e "tell application \"Chrome\" to activate"
osascript -e "tell application \"Slack\" to activate"
cd /Users/olof/dev/osandell/workspace-switcher
yarn start &

while true; do
    sleep 60
done
