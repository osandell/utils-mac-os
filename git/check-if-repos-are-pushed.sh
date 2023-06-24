#!/bin/bash

# OBS! Since Mac OS prevents screen sharing for the Chrome instances started
# with a custom launcher I've decided to use Google Chrome Grebban as my screen
# sharing profile used for Google Meet etc. I've thus made "Grebban" the
# standard profile for Chrome and then I launch "Google Chrome Grebban.app"
# directly instead of via my custom launcher. I've also turned on syncing via
# Google for this particular profile so we don't need to include it here.
hasBookmarksOnlyBeenModified() {
  CHROME_INSTANCES=(Dev Personal YouTube Music Incognito)
  for i in "${CHROME_INSTANCES[@]}"; do
    if [[ "$1" == *"Changes not staged for commit:...modified: Users/olof/Library/Application Support/Google/Chrome/${i} Profile/Default/Bookmarks...no changes added to commit"* ]]; then
      return 1
    fi
  done
  return 0
}

[ ! -f /usr/local/bin/switchaudiosource ] && /usr/local/bin/brew install switchaudio-osx

NEEDS_PUSH=false

OUTPUT=$(/usr/bin/git --git-dir=/Users/olof/.config-system-specific/ --work-tree=/ status)
if [[ "$OUTPUT" != *"nothing to commit"* || "$OUTPUT" != *"Your branch is up to date with"* ]]; then
  NEEDS_PUSH=true
  hasBookmarksOnlyBeenModified "$OUTPUT"
  HAS_BOOKMARKS_ONLY_BEEN_MODIFIED=$?
  if [[ $HAS_BOOKMARKS_ONLY_BEEN_MODIFIED == 1 ]]; then
    /usr/bin/git --git-dir=/Users/olof/.config-system-specific/ --work-tree=/ add -u
    /usr/bin/git --git-dir=/Users/olof/.config-system-specific/ --work-tree=/ commit -m "chrome: update bookmarks"
    /usr/bin/git --git-dir=/Users/olof/.config-system-specific/ --work-tree=/ push
  else
    osascript -e 'say "Dont forget to push system specific config"'
  fi
fi

OUTPUT=$(/usr/bin/git --git-dir=/Users/olof/.config-shared/ --work-tree=/Users/olof/ status)
if [[ "$OUTPUT" != *"nothing to commit"* || "$OUTPUT" != *"Your branch is up to date with"* ]]; then
  NEEDS_PUSH=true
  osascript -e 'say "Dont forget to push shared config"'
fi

FOLDERS=(/Users/olof/dev/osandell/*/)
FOLDERS=("${FOLDERS[@]%/}")
FOLDERS=("${FOLDERS[@]##*/}")
for i in "${FOLDERS[@]}"; do
  OUTPUT=$(cd /Users/olof/dev/osandell/$i && /usr/bin/git status)
  if [[ ("$OUTPUT" != *"nothing to commit"* || "$OUTPUT" != *"Your branch is up to date with"*) && "$OUTPUT" != "" ]]; then
    NEEDS_PUSH=true
    osascript -e "say \"Dont forget to push $i in osandell\""
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
    NEEDS_PUSH=true
    osascript -e "
        say \"Dont forget to push $i in olofgrebban\"
        "
  fi
done

if ! $NEEDS_PUSH; then
  osascript -e 'say "Everything is up to date"'
fi
