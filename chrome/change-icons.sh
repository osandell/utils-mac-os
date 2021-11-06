#!/bin/bash

# FileIcon is installed via Brew: https://formulae.brew.sh/formula/fileicon

# Put the .plist file in ~/Library/LaunchAgents to launch at login

/usr/local/bin/fswatch -0 /Applications | while read -d "" event
  do 
   # We make sure to use the full path of executables, otherwise the launch daemon will not find them 
   [[ $event =~ "/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome" ]] && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Dev.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/dev.png
   [[ $event =~ "/Applications/Google Chrome Grebban.app/Contents/MacOS/Google Chrome" ]] && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Grebban.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/grebban.png
   [[ $event =~ "/Applications/Google Chrome Incognito.app/Contents/MacOS/Google Chrome" ]] && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Incognito.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/incognito.png
   [[ $event =~ "/Applications/Google Chrome Music.app/Contents/MacOS/Google Chrome" ]] && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Music.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/music.png
   [[ $event =~ "/Applications/Google Chrome Personal.app/Contents/MacOS/Google Chrome" ]] && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Personal.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/personal.png
   [[ $event =~ "/Applications/Google Chrome YouTube.app/Contents/MacOS/Google Chrome" ]] && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ YouTube.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/youtube.png
done
