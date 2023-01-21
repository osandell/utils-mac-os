#!/bin/bash

[ ! -f /usr/local/bin/switchaudiosource ] && /usr/local/bin/brew install switchaudio-osx
OUTPUT=$(/usr/bin/git --git-dir=/Users/olof/.config-system-specific/ --work-tree=/ status)
if [[ "$OUTPUT" != *"nothing to commit"* || "$OUTPUT" != *"Your branch is up to date with"* ]]; then
  hasBookmarksOnlyBeenModified "$OUTPUT"
  ALL_MODIFIED_FILES=$(/usr/bin/git --git-dir=/Users/olof/.config-system-specific/ --work-tree=/ status | grep '^.*modified')
  MODIFIED_BOOKMARKS=$(/usr/bin/git --git-dir=/Users/olof/.config-system-specific/ --work-tree=/ status | grep '^.*modified.*/Bookmarks')

  if [[ $ALL_MODIFIED_FILES == $MODIFIED_BOOKMARKS ]]; then
    /usr/bin/git --git-dir=/Users/olof/.config-system-specific/ --work-tree=/ add -u
    /usr/bin/git --git-dir=/Users/olof/.config-system-specific/ --work-tree=/ commit -m "chrome: update bookmarks"
    /usr/bin/git --git-dir=/Users/olof/.config-system-specific/ --work-tree=/ push
  else
    /usr/local/bin/switchaudiosource -s "Högtalare i MacBook Pro"
    osascript -e '
      set Volume 3
      say "Dont forget to push system specific config"
    '
  fi
fi

OUTPUT=$(/usr/bin/git --git-dir=/Users/olof/.config-shared/ --work-tree=/Users/olof/ status)
if [[ "$OUTPUT" != *"nothing to commit"* || "$OUTPUT" != *"Your branch is up to date with"* ]]; then
  /usr/local/bin/switchaudiosource -s "Högtalare i MacBook Pro"
  osascript -e '
    set Volume 3
    say "Dont forget to push shared config"
    '
fi

# Check osandell projects
FOLDERS=(/Users/olof/dev/osandell/*/) # This creates an array of the full paths to all subdirs
FOLDERS=("${FOLDERS[@]%/}")           # This removes the trailing slash on each item
FOLDERS=("${FOLDERS[@]##*/}")         # This removes the path prefix, leaving just the dir names
for i in "${FOLDERS[@]}"; do
  OUTPUT=$(cd /Users/olof/dev/osandell/$i && /usr/bin/git status)
  if [[ ("$OUTPUT" != *"nothing to commit"* || "$OUTPUT" != *"Your branch is up to date with"*) && "$OUTPUT" != "" ]]; then
    echo "\n\nDon't forget to push $i!\n\n"
    /usr/local/bin/switchaudiosource -s "Högtalare i MacBook Pro"
    osascript -e "
        set Volume 3
        say \"Dont forget to push $i in osandell\"
        "
  fi
done

# Check olofgrebban projects
FOLDERS=(/Users/olof/dev/olofgrebban/*/) # This creates an array of the full paths to all subdirs
FOLDERS=("${FOLDERS[@]%/}")              # This removes the trailing slash on each item
FOLDERS=("${FOLDERS[@]##*/}")            # This removes the path prefix, leaving just the dir names
for i in "${FOLDERS[@]}"; do
  OUTPUT=$(cd /Users/olof/dev/olofgrebban/$i && /usr/bin/git status)
  if [[ ("$OUTPUT" != *"nothing to commit"* || "$OUTPUT" != *"Your branch is up to date with"*) &&

    "$OUTPUT" != "" && "$i" != "byon-frontend" && "$i" != "zoo-api" ]]; then # I can't push the byon branch since i don't have permissions for some reason.
    # I don't want to push the Zoo Api since it contains a password.. not sure if it's ok to push it
    echo "\n\nDon't forget to push $i!\n\n"
    /usr/local/bin/switchaudiosource -s "Högtalare i MacBook Pro"
    osascript -e "
        set Volume 3
        say \"Dont forget to push $i in olofgrebban\"
        "
  fi
done
