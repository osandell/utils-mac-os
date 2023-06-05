ignoring application responses
	tell application "System Events" to Â
		click menu bar item 1 of menu bar 2 of Â
			application process "TextInputMenuAgent"
end ignoring

delay 0.1
do shell script "killall 'System Events'"
delay 0.2

tell application "System Events"
	launch
	click menu item "QWERTY Old" of menu 1 of Â
		menu bar item 1 of menu bar 2 of Â
		application process "TextInputMenuAgent"
end tell


