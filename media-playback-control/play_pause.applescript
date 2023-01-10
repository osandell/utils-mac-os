tell application "Finder"
	set mediaPlayerAction to (path to home folder as text) & "dev:osandell:scripts-osx:media-playback-control:media-player-action.applescript" as alias
end tell

run script mediaPlayerAction with parameters {"play"}