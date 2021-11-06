set figmaIsActive to false

if (path to frontmost application as text) contains "Google Chrome Grebban" then
	tell application "Google Chrome Personal"
		if (title of front window as string) contains " – Figma" then
			set figmaIsActive to true
		end if
	end tell
end if

if figmaIsActive is false then
	tell application "System Events"
		try
			keystroke "m" using command down
		end try
	end tell
end if
