#!/bin/bash

# FileIcon is installed via Brew: https://formulae.brew.sh/formula/fileicon

# Put the .plist file in ~/Library/LaunchAgents to launch at login

/usr/local/bin/fswatch -0 /Applications | while read -d "" event
  do 
   # We make sure to use the full path of executables, otherwise the launch
   # daemon will not find them. For some reason after I upgraded Mac OS I had to
   # first run mv to rename the file in order to get permission to then later
   # use fileicon. I have no idea why but I decided to build that rename back
   # and forth into this script so we don't need to bother with it after every
   # upgrade.
   [[ $event =~ "/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome" ]] &&  mv /Applications/Google\ Chrome\ Dev.app /Applications/Google\ Chrome\ Dev.appp &&  mv /Applications/Google\ Chrome\ Dev.appp /Applications/Google\ Chrome\ Dev.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Dev.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/dev.png
   [[ $event =~ "/Applications/Google Chrome Grebban.app/Contents/MacOS/Google Chrome" ]] &&  mv /Applications/Google\ Chrome\ Grebban.app /Applications/Google\ Chrome\ Grebban.appp &&  mv /Applications/Google\ Chrome\ Grebban.appp /Applications/Google\ Chrome\ Grebban.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Grebban.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/grebban.png
   [[ $event =~ "/Applications/Google Chrome Incognito.app/Contents/MacOS/Google Chrome" ]] &&  mv /Applications/Google\ Chrome\ Incognito.app /Applications/Google\ Chrome\ Incognito.appp &&  mv /Applications/Google\ Chrome\ Incognito.appp /Applications/Google\ Chrome\ Incognito.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Incognito.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/incognito.png
   [[ $event =~ "/Applications/Google Chrome Music.app/Contents/MacOS/Google Chrome" ]] &&  mv /Applications/Google\ Chrome\ Music.app /Applications/Google\ Chrome\ Music.appp &&  mv /Applications/Google\ Chrome\ Music.appp /Applications/Google\ Chrome\ Music.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Music.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/music.png
   [[ $event =~ "/Applications/Google Chrome Personal.app/Contents/MacOS/Google Chrome" ]] &&  mv /Applications/Google\ Chrome\ Personal.app /Applications/Google\ Chrome\ Personal.appp &&  mv /Applications/Google\ Chrome\ Personal.appp /Applications/Google\ Chrome\ Personal.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Personal.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/personal.png
   [[ $event =~ "/Applications/Google Chrome YouTube.app/Contents/MacOS/Google Chrome" ]] &&  mv /Applications/Google\ Chrome\ YouTube.app /Applications/Google\ Chrome\ YouTube.appp &&  mv /Applications/Google\ Chrome\ YouTube.appp /Applications/Google\ Chrome\ YouTube.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ YouTube.app /Users/olof/dev/osandell/scripts-osx/chrome/icons/youtube.png
done
