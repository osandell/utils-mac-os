tell application "System Events"
	tell process "NotificationCenter"
		repeat
			# Close this process as soon as all the notifications are gone
			try
				set theWindow to window "Notification Center"
			on error
				exit repeat
			end try
			
			# This is the clear all button when multiple notifications are expanded
			# Try using this first. If it doesn't exist it means the notifications
			# are collapsed and we need to use another method of closing.
			tell button 2 of UI element 1 of scroll area 1 of group 1 of theWindow
				if exists then
					click
				else
					try
						set theActions to actions of group 1 of UI element 1 of scroll area 1 of group 1 of theWindow
						
						# Try to close the whole group first. If that fails, close individual windows.
						repeat with theAction in theActions
							if description of theAction is "Clear all" then
								tell theWindow
									perform theAction
								end tell
								exit repeat
							end if
						end repeat
						
						repeat with theAction in theActions
							if description of theAction is "Close" then
								set closed to true
								tell theWindow
									perform theAction
								end tell
								exit repeat
							end if
						end repeat
					end try
				end if
			end tell
		end repeat
	end tell
end tell
