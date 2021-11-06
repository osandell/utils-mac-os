tell application "Google Chrome Grebban"
	set i to 0
	repeat with t in tabs of front window
		set i to i + 1
		if title of t contains "Jira" then
			set active tab index of front window to i
			return
		end if
	end repeat
end tell

