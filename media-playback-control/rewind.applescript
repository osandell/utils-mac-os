tell application "Finder"
	set mediaPlayerAction to (container of (path to me) as text) & "media-player-action.applescript" as alias
end tell

run script mediaPlayerAction with parameters {"rewind"}