set runningProcesses to do shell script "ps -ax"

if (runningProcesses contains "Applications.localized/Visual Studio 2022.app") then
	tell application "Visual Studio 2022" to activate
else
tell application "Code" to activate
end if