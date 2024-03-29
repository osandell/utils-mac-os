tell application "System Events"
	tell process "Focus To-Do"
		
		# The number of the group with the play / pause button changes if we open the right pane by double clicking a 
		# subtask or go to the view with red covering the whole window. Therefore we use "last group" and calculate from that.
		
		set nrOfGroups to length of (get every UI element of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1)
		
		set timerTextBig to name of static text of group (nrOfGroups - 1) of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 as string
		
		# When the countdown timer is in compact format the path varies between 2 alternatives
		if group 1 of group (nrOfGroups - 2) of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 exists then
			set timerTextSmall to name of static text of group 1 of group (nrOfGroups - 2) of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 as string
		else
			set timerTextSmall to name of static text of group (nrOfGroups - 2) of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 as string
		end if
		
		# If a pomodoro is paused...
		if (get length of (get every UI element of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1)) = 2 then
			
			tell application "System Events"
				do shell script ("afplay " & POSIX path of (container of (path to me)) & "/play.wav > /dev/null 2>&1 &")
			end tell
			
			try
				click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
			on error
				display dialog "Error: could not find the button to click!"
			end try
			
			# If a pomodoro is running or about to start, a break is running or we are just about to start a break...
		else
			
			# If a pomodoro is about to start...
			if timerTextBig = "30:00" or timerTextSmall = "30" then
				tell application "System Events"
					do shell script ("afplay " & POSIX path of (container of (path to me)) & "/play.wav > /dev/null 2>&1 &")
					
					tell process "Notiscenter"
						try
							set theWindow to window "Notification Center"
							set notifications to groups of UI element 1 of scroll area 1 of theWindow
							repeat with notification in notifications
								set notificationTitle to name of static text 1 of notification
								if notificationTitle = "☕️Pausen är färdig." then
									set theActions to actions of notification
									repeat with theAction in theActions
										if description of theAction is "Stäng" then
											tell theWindow
												perform theAction
											end tell
											exit repeat
										end if
									end repeat
								end if
							end repeat
						end try
					end tell
				end tell
				
				try
					click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
				on error
					display dialog "Error: could not find the button to click!"
				end try
				# If a pomodoro is running, a pause is running or we are just about to start a break...
			else
				
				try
					click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
				on error
					display dialog "Error: could not find the button to click!"
				end try
				
				delay 0.1
				
				# If we just clicked the Finish Pause button then play the 'play' sound and click again to start the pomodoro...
				if timerTextBig = "30:00" or timerTextSmall = "30" then
					tell application "System Events"
						do shell script ("afplay " & POSIX path of (container of (path to me)) & "/play.wav > /dev/null 2>&1 &")
					end tell
					
					try
						click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
					on error
						display dialog "Error: could not find the button to click!"
					end try
					# If a pomodoro was running, or we were about to start a break when we clicked then just play the pause sound
				else
					tell application "System Events"
						do shell script ("afplay " & POSIX path of (container of (path to me)) & "/pause.wav > /dev/null 2>&1 &")
						
						tell process "Notiscenter"
							try
								set theWindow to window "Notification Center"
								set notifications to groups of UI element 1 of scroll area 1 of theWindow
								repeat with notification in notifications
									set notificationTitle to name of static text 1 of notification
									log notificationTitle
									if notificationTitle = "🎉Pomodoro är klar." then
										set theActions to actions of notification
										repeat with theAction in theActions
											if description of theAction is "Stäng" then
												tell theWindow
													perform theAction
												end tell
												exit repeat
											end if
										end repeat
									end if
								end repeat
							end try
						end tell
					end tell
				end if
			end if
		end if
	end tell
end tell