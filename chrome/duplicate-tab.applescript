if (path to frontmost application as text) contains "Google Chrome Grebban" then
	tell application "Google Chrome Grebban"
		tell front window to make new tab with properties {URL:URL of active tab}
	end tell
else if (path to frontmost application as text) contains "Google Chrome Music" then
	tell application "Google Chrome Music"
		tell front window to make new tab with properties {URL:URL of active tab}
	end tell
else if (path to frontmost application as text) contains "Google Chrome Personal" then
	tell application "Google Chrome Personal"
		tell front window to make new tab with properties {URL:URL of active tab}
	end tell
else if (path to frontmost application as text) contains "Google Chrome YouTube" then
	tell application "Google Chrome YouTube"
		tell front window to make new tab with properties {URL:URL of active tab}
	end tell
else if (path to frontmost application as text) contains "Google Chrome Dev" then
	tell application "Google Chrome Dev"
		tell front window to make new tab with properties {URL:URL of active tab}
	end tell
else if (path to frontmost application as text) contains "Google Chrome Incognito" then
	tell application "Google Chrome Incognito"
		tell front window to make new tab with properties {URL:URL of active tab}
	end tell
end if

