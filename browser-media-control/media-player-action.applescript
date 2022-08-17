on run {action}
	tell application "System Events"
		set pid to the unix id of first process where it is frontmost
	end tell
	
	set foundMediaPlayer to false
	
	try
		tell application "Google Chrome Personal"
			if URL of active tab of first window contains "webdevsimplified.com" or URL of active tab of first window contains "udemy.com" then
				activate
				set foundMediaPlayer to true
			end if
		end tell
	end try
	if foundMediaPlayer then
		runAction(action, pid)
		return
	end if
	
	try
		tell application "Google Chrome Grebban"
			if URL of active tab of first window contains "webdevsimplified.com" or URL of active tab of first window contains "udemy.com" then
				activate
				set foundMediaPlayer to true
			end if
		end tell
	end try
	if foundMediaPlayer then
		runAction(action, pid)
		return
	end if
	
	try
		tell application "Google Chrome Personal"
			if URL of active tab of first window contains "youtube" then
				if (action as string) is equal to "play" then
					tell active tab of front window to execute javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].click();"
				else if action is "forward" then
					activate
					tell application "System Events"
						key code 124 # right arrow
					end tell
				else if action is "rewind" then
					activate
					tell application "System Events"
						key code 123 # left arrow
					end tell
				end if
				delay 0.1
				tell application "System Events"
					set theprocs to every process whose unix id is pid
					repeat with proc in theprocs
						
						set frontmost of proc to true
					end repeat
				end tell
				return
			end if
		end tell
	end try
	
	try
		tell application "Google Chrome Music"
			if URL of active tab of first window contains "youtube" then
				if (action as string) is equal to "play" then
					tell active tab of front window to execute javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].click();"
				else if action is "forward" then
					activate
					tell application "System Events"
						key code 124 # right arrow
					end tell
				else if action is "rewind" then
					activate
					tell application "System Events"
						key code 123 # left arrow
					end tell
				end if
				delay 0.1
				tell application "System Events"
					set theprocs to every process whose unix id is pid
					repeat with proc in theprocs
						
						set frontmost of proc to true
					end repeat
				end tell
			end if
		end tell
	end try
end run

on runAction(action, pid)
	if (action as string) is equal to "play" then
		tell application "System Events"
			key code 49 # space
		end tell
	else if action is "forward" then
		tell application "System Events"
			key code 124 # right arrow
		end tell
	else if action is "rewind" then
		tell application "System Events"
			key code 123 # left arrow
		end tell
	end if
	delay 0.1
	tell application "System Events"
		set theprocs to every process whose unix id is pid
		repeat with proc in theprocs
			
			set frontmost of proc to true
		end repeat
	end tell
end runAction