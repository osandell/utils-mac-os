on run {action}
	tell application "System Events"
		set lastActiveAppName to the name of first process where it is frontmost
	end tell
	tell application "System Events"
		set pid to the unix id of first process where it is frontmost
	end tell
	
	set runningProcesses to do shell script "ps -ax"
	
	if (runningProcesses contains "/Applications/VLC.app/Contents/MacOS/VLC") then
		# By not calling "tell application..." directly we avoid the app starting
		# even though this if statement is false.
		do shell script "open -a VLC & osascript -e 'tell application  \"VLC\" to play'"
		
		delay 0.1
		
		# VSCode has a lot of running processess so we can pinpoint with the default method.
		if (lastActiveAppName is "Electron") then
			# This way we only raise window 1 instead of all of them.
			do shell script "open -a Visual\\ Studio\\ Code"
		else
			set activateLastActiveWindow to POSIX path of ((path to me as text) & "::") & "open_with_pid.sh " & pid
			do shell script activateLastActiveWindow
			return activateLastActiveWindow
		end if
		
	else
		set foundMediaPlayer to false
		
		try
			tell application "Google Chrome Personal"
				if URL of active tab of first window contains "webdevsimplified.com" or URL of active tab of first window contains "udemy.com" or URL of active tab of first window contains "frontendmasters.com" then
					activate
					set foundMediaPlayer to true
				end if
				if title of active tab of first window contains "Workshop" or URL of active tab of first window contains "workshop" or URL of active tab of first window contains "Tutorial" or URL of active tab of first window contains "tutorial" then
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
	end if
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