on writeTextToFile(theText, theFile, overwriteExistingContent)
	try
		
		-- Convert the file to a string
		set theFile to theFile as string
		
		-- Open the file for writing
		set theOpenedFile to open for access file theFile with write permission
		
		-- Clear the file if content should be overwritten
		if overwriteExistingContent is true then set eof of theOpenedFile to 0
		
		-- Write the new content to the file
		write theText to theOpenedFile starting at eof
		
		-- Close the file
		close access theOpenedFile
		
		-- Return a boolean indicating that writing was successful
		return true
		
		-- Handle a write error
	on error
		
		-- Close the file
		try
			close access file theFile
		end try
		
		-- Return a boolean indicating that writing failed
		return false
	end try
end writeTextToFile

on readFile(theFile)
	-- Convert the file to a string
	set theFile to theFile as string
	
	-- Read the file and return its contents
	return read file theFile
end readFile


tell application "Finder"
	set theFile to (container of (path to me) as text) & "config.txt"
end tell

if readFile(theFile) contains "TRUE" then
	tell application "System Events" to set app_directory to POSIX path of (container of (path to me))
	set thescript to ("cp " & quoted form of (app_directory & "/com.logitech.manager.setting.000eb020-minimize.plist") & " ~/Library/Preferences/com.logitech.manager.setting.000eb020.plist && killall LogiMgrDaemon")
	do shell script thescript
	writeTextToFile("MIDDLE_MOUSE_TO_MINIMIZE_WINDOW = FALSE", theFile, true)
	display dialog "Middle Mouse Button to Minimize Window activated" giving up after 2
	
else
	tell application "System Events" to set app_directory to POSIX path of (container of (path to me))
	set thescript to ("cp " & quoted form of (app_directory & "/com.logitech.manager.setting.000eb020-middle-button.plist") & " ~/Library/Preferences/com.logitech.manager.setting.000eb020.plist && killall LogiMgrDaemon")
	do shell script thescript
	writeTextToFile("MIDDLE_MOUSE_TO_MINIMIZE_WINDOW = TRUE", theFile, true)
	display dialog "Middle Mouse Button to Minimize Window deactivated" giving up after 2
end if




