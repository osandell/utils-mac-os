tell application "System Events"
	do shell script ("afplay " & POSIX path of (container of (path to me)) & "/next.wav > /dev/null 2>&1 &")

	tell process "Notiscenter"
		try
			set theWindow to window "Notification Center"
			set notifications to groups of UI element 1 of scroll area 1 of group 1 of theWindow
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
	
	delay 0.1
	
	tell process "Focus To-Do"
		
		# Theee number of the group with the play / pause button changes if we open the right pane by double clicking a 
		# subtask or go to the view with red covering the whole window. Therefore we use "last group" and calculate from that.
		
		set nrOfGroups to length of (get every UI element of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1)
		
		set timerTextBig to name of static text of group (nrOfGroups - 1) of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 as string
		
		# When the countdown timer is in compact format the path varies between 2 alternatives
		if group 1 of group (nrOfGroups - 2) of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 exists then
			set timerTextSmall to name of static text of group 1 of group (nrOfGroups - 2) of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 as string
		else
			set timerTextSmall to name of static text of group (nrOfGroups - 2) of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1 as string
		end if
		
		log timerTextBig
		log timerTextSmall
		
		# If pomodoro is finished and the 10 min break is ready to begin...
		if timerTextBig = "10:00" or timerTextSmall = "10:00" or timerTextSmall = "10" then
			try
				# Click the Play button
				click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
				delay 0.1
				
				# Click the Finish Pause button
				
				click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
				delay 0.1
				
				# Click the Play button
				click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
				
			on error
				display dialog "Error: could not find the button to click!"
			end try
			
			
			# If pomodoro is ready to begin...
		else if timerTextBig = "30:00" or timerTextSmall = "30:00" or timerTextSmall = "30" then
			try
				
				# Click the Play button
				click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
				
			on error
				display dialog "Error: could not find the button to click!"
			end try
		else
			log (get name of static text of group (nrOfGroups - 1) of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1)
			
			# If pomodoro is paused...
			if (get length of (get every UI element of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1)) = 2 then
				try
					# Click the Stop button
					click group 2 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
					delay 0.1
					
					# Click the Finish Pomodoro button
					click UI element 2 of group 10 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
					delay 0.1
					
					# Click the Play button
					click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
					
				on error
					display dialog "Error: could not find the button to click!"
				end try
				
				# If pomodoro or pause is running...
			else
				try
					# Click the Pause / Finish Pause button
					click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
					delay 0.1

					# If we've just paused a pomodoro we need to handle the dialoge box
					if (get length of (get every UI element of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1)) = 2 then
						
						# Click the Stop button
						click group 2 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
						delay 0.1
						
						# Click the Finish Pomodoro button
						click UI element 2 of group 10 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
					end if
					
					# Click the Play button
					click group 1 of last group of group 2 of UI element 1 of scroll area 1 of group 1 of group 1 of window 1
					
				on error
					display dialog "Error: could not find the button to click!"
				end try
			end if
			
		end if
	end tell
end tell
