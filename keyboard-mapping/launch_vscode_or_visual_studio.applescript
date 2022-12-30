set runningProcesses to do shell script "ps -ax"

if (runningProcesses contains "Applications.localized/Visual Studio 2022.app") then
	tell application "Visual Studio 2022" to activate
else
	if (runningProcesses contains "/Applications/VLC.app/Contents/MacOS/VLC") then
		do shell script "open -a VLC"
	end if
	
	# This way we only raise window 1 instead of all of them.
	do shell script "open -a Visual\\ Studio\\ Code"
end if