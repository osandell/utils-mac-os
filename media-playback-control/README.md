# Browser Media Control

This is a collection of scripts for playing, pausing, fast forwarding and rewinding media.

## Usage
Activate the script files from for example Karabiner with Osascript

Use Logi Options to map the media buttons on the keyboard to the App files. Make sure they have permission to be opened in System Settings.

If the icon shows up in the dock while executing the App files:
1. Open the Info.plist inside the package content of the App file in XCode
2. Add a new line containing 'LSUIElement' (Application is agent) and set to 'YES'
3. Delete the app from System Preferences => Integrity & Security => Accessibility if existing there
4. Run the app once and click 'Edit' when the error dialog comes up
5. Save the file
6. In System Preferences add back the app by clicking the +
7. Check the box next to the app in question
