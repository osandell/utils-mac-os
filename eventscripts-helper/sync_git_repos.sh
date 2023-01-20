#!/bin/bash

# Test sleeping 20s so we hopefully get internet
# osascript -e "say \"sleeping 20 seconds\""
sleep 20
# osascript -e "say \"sleep is done\""

########################################################################
# Pull any changes to git repos
########################################################################
OUTPUT=$(/usr/bin/git --git-dir=$HOME/.config-system-specific/ --work-tree=/ pull 2>&1)
if [[ "$OUTPUT" != *"Already up to date."* && "$OUTPUT" != *" file changed, "* 
&& "$OUTPUT" != *" files changed, "* && "$OUTPUT" != *"Successfully rebased"* ]]; then
    osascript -e "
       display alert \"config-system-specific:\n\n $OUTPUT\"
        "
fi
CHROME_INSTANCES=( Dev Personal YouTube Music Incognito )
for i in "${CHROME_INSTANCES[@]}"
  do
    if [[ "$OUTPUT" == *"$i Profile/Default/Bookmarks"* ]]; then
      osascript -e "
        try
        tell application \"Google Chrome $i\" to quit
        end try
        delay 1
        tell application \"Chrome $i\" to run
      "
    fi
  done

OUTPUT=$(/usr/bin/git --git-dir=$HOME/.config-shared/ --work-tree=$HOME pull 2>&1)
if [[ "$OUTPUT" != *"Already up to date."* && "$OUTPUT" != *" file changed, "* 
&& "$OUTPUT" != *" files changed, "* && "$OUTPUT" != *"Successfully rebased"* ]]; then
    osascript -e "
        display alert \"config-shared:\n\n $OUTPUT\"
        "
fi

FOLDERS=(/Users/olof/dev/osandell/*/)    # This creates an array of the full paths to all subdirs
FOLDERS=("${FOLDERS[@]%/}")            # This removes the trailing slash on each item
FOLDERS=("${FOLDERS[@]##*/}")          # This removes the path prefix, leaving just the dir names
for i in "${FOLDERS[@]}"
  do
    OUTPUT=$(cd /Users/olof/dev/osandell/$i && /usr/bin/git pull 2>&1)
    if [[ "$OUTPUT" != *"Already up to date."* && "$OUTPUT" != *"not a git repository"*
    && "$OUTPUT" != *" file changed, "* && "$OUTPUT" != *" files changed, "* && "$OUTPUT" != *"Successfully rebased"* ]]; then
       osascript -e "
        display alert \"$i:\n\n $OUTPUT\"
        "
    fi
  done

FOLDERS=(/Users/olof/dev/olofgrebban/*/)    # This creates an array of the full paths to all subdirs
FOLDERS=("${FOLDERS[@]%/}")            # This removes the trailing slash on each item
FOLDERS=("${FOLDERS[@]##*/}")          # This removes the path prefix, leaving just the dir names
for i in "${FOLDERS[@]}"
  do
    OUTPUT=$(cd /Users/olof/dev/olofgrebban/$i && /usr/bin/git pull 2>&1)
    if [[ "$OUTPUT" != *"Already up to date."* && "$OUTPUT" != *"not a git repository"*
    && "$OUTPUT" != *" file changed, "* && "$OUTPUT" != *" files changed, "* && "$OUTPUT" != *"Successfully rebased"*
    # I can't pull from the byon branch since i don't have permissions for some reason.
    # I can't pull from Zoo Api since I'm using a local branch that i don't want to push since it contains a password.. not sure if it's ok to push it
    && "$OUTPUT" != "" && "$i" != "byon-frontend" && "$i" != "zoo-api" ]]; then
        osascript -e "
        display alert \"$i:\n\n $OUTPUT\"
        "
    fi
  done 

######################################################################## 
# Restart EventScripts in case the just conducted sync has caused the
# EvntScripts settings to change. We use the & sign in order detach the
# other script since not doing so would cause a hangup (it can't terminate it's
# own parent).
########################################################################
/restart-event-scripts.sh &


