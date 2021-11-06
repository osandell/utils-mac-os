tell application "System Events"
	tell process "Notiscenter"
		try
			set theWindow to window "Notification Center"
		on error
			exit repeat
		end try
		
		set theActions to actions of group 1 of UI element 1 of scroll area 1 of theWindow
		# Try to close the whole group first. If that fails, close individual windows.
		repeat with theAction in theActions
			if description of theAction is "Snooze" then
				tell application "System Events"
					do shell script ("afplay " & POSIX path of (container of (path to me)) & "/snooze.wav > /dev/null 2>&1 &")
				end tell
				tell theWindow
					perform theAction
				end tell
				exit repeat
			end if
		end repeat
	end tell
end tell

