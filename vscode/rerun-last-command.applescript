tell application "System Events"
	key code 53 # Esc - exit insert mode
	delay 0.1
	
	keystroke "s" using {command down} # Save
	delay 0.1
	
	keystroke "t" using {control down, shift down} # Go down to terminal
	delay 0.1
	
	keystroke "c" using {control down} # Exit any running process
	delay 0.1
	
	key code 126 # Up Arrow - last command
	delay 0.1
	
	key code 76 # Enter
	delay 0.1
	
	keystroke "e" using {option down, shift down} # Go back to editor
end tell
