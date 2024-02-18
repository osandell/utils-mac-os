#!/bin/bash

# Sort out the Chrome windows after reboot since Mac OS gets confused when you
# have multiple instances of the same app running.
osascript <<END
set volume with output muted
tell application "Google Chrome" to quit
delay 2
do shell script "open -a Google\\\ Chrome\\\ Grebban"
delay 3
do shell script "open -a Chrome\\\ Music"
do shell script "open -a Chrome\\\ Dev"
do shell script "open -a Chrome\\\ Personal"
delay 3

tell application "Google Chrome Music" to tell the active tab of its first window to reload

tell application "Google Chrome Grebban"
  set window_list to every window
  
  repeat with the_window in window_list
    set tab_list to every tab in the_window
    
    repeat with the_tab in tab_list
      if the title of the_tab is "Google" then
        close the_tab
      end if
    end repeat
  end repeat

  activate
end tell

delay 10

tell application "Finder"
	set mediaPlayerAction to (path to home folder as text) & "dev:osandell:utils-max-of:media-playback-control:media-player-action.applescript" as alias
end tell
run script mediaPlayerAction with parameters {"play"}
delay 1
set volume without output muted


END

# FileIcon is installed via Brew: https://formulae.brew.sh/formula/fileicon

# This script is easily run on startup by using pm2: https://pm2.keymetrics.io/docs/usage/quick-start/

/usr/local/bin/fswatch -0 /Applications | while read -d "" event; do
  # We make sure to use the full path of executables, otherwise the launch
  # daemon will not find them. For some reason after I upgraded Mac OS I had to
  # first run mv to rename the file in order to get permission to then later
  # use fileicon. I have no idea why but I decided to build that rename back
  # and forth into this script so we don't need to bother with it after every
  # upgrade.
  [[ $event =~ "/Applications/Google Chrome Dev.app/Contents/MacOS/Google Chrome" ]] && mv /Applications/Google\ Chrome\ Dev.app /Applications/Google\ Chrome\ Dev.appp && mv /Applications/Google\ Chrome\ Dev.appp /Applications/Google\ Chrome\ Dev.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Dev.app /Users/olof/dev/osandell/utils-max-of/chrome/icons/dev.png
  [[ $event =~ "/Applications/Google Chrome Grebban.app/Contents/MacOS/Google Chrome" ]] && mv /Applications/Google\ Chrome\ Grebban.app /Applications/Google\ Chrome\ Grebban.appp && mv /Applications/Google\ Chrome\ Grebban.appp /Applications/Google\ Chrome\ Grebban.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Grebban.app /Users/olof/dev/osandell/utils-max-of/chrome/icons/grebban.png
  [[ $event =~ "/Applications/Google Chrome Incognito.app/Contents/MacOS/Google Chrome" ]] && mv /Applications/Google\ Chrome\ Incognito.app /Applications/Google\ Chrome\ Incognito.appp && mv /Applications/Google\ Chrome\ Incognito.appp /Applications/Google\ Chrome\ Incognito.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Incognito.app /Users/olof/dev/osandell/utils-max-of/chrome/icons/incognito.png
  [[ $event =~ "/Applications/Google Chrome Music.app/Contents/MacOS/Google Chrome" ]] && mv /Applications/Google\ Chrome\ Music.app /Applications/Google\ Chrome\ Music.appp && mv /Applications/Google\ Chrome\ Music.appp /Applications/Google\ Chrome\ Music.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Music.app /Users/olof/dev/osandell/utils-max-of/chrome/icons/music.png
  [[ $event =~ "/Applications/Google Chrome Personal.app/Contents/MacOS/Google Chrome" ]] && mv /Applications/Google\ Chrome\ Personal.app /Applications/Google\ Chrome\ Personal.appp && mv /Applications/Google\ Chrome\ Personal.appp /Applications/Google\ Chrome\ Personal.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ Personal.app /Users/olof/dev/osandell/utils-max-of/chrome/icons/personal.png
  [[ $event =~ "/Applications/Google Chrome YouTube.app/Contents/MacOS/Google Chrome" ]] && mv /Applications/Google\ Chrome\ YouTube.app /Applications/Google\ Chrome\ YouTube.appp && mv /Applications/Google\ Chrome\ YouTube.appp /Applications/Google\ Chrome\ YouTube.app && /usr/local/bin/fileicon set /Applications/Google\ Chrome\ YouTube.app /Users/olof/dev/osandell/utils-max-of/chrome/icons/youtube.png
done
