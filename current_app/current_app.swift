import ApplicationServices
import Cocoa

func executeCurlCommand(data: String) {
  let process = Process()
  process.launchPath = "/usr/bin/env"
  process.arguments = ["curl", "-X", "POST", "localhost:57321", "-d", data]

  let pipe = Pipe()
  process.standardOutput = pipe
  process.standardError = pipe

  process.launch()
}

func saveAppName(appName: String) {
  let filePath = "/tmp/current_app.txt"
  do {
    try appName.write(toFile: filePath, atomically: true, encoding: .utf8)
  } catch {
    print("Failed to write app name to file: \(error)")
  }
}

NSWorkspace.shared.notificationCenter.addObserver(
  forName: NSWorkspace.didActivateApplicationNotification, object: nil, queue: OperationQueue.main
) { notification in
  if let app = notification.userInfo?[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
    let appName = app.localizedName
  {

    var title: String? = nil

    // Get the PID of the frontmost application
    let pid = app.processIdentifier

    // Create an AXUIElement representing the application
    let appElement = AXUIElementCreateApplication(pid)

    var value: AnyObject?

    // Attempt to get the title of the focused window
    let result = AXUIElementCopyAttributeValue(
      appElement, kAXFocusedWindowAttribute as CFString, &value)

    if result == .success, let window = value as! AXUIElement? {
      AXUIElementCopyAttributeValue(window, kAXTitleAttribute as CFString, &value)
      title = value as? String
    }

    if appName == "Code" || appName == "Electron" || (appName == "kitty" && title != "kitty-lf") {  // Assuming "Elecr" was a typo for "Electron"
      print("Code or Electron is frontmost")
      executeCurlCommand(data: "setIsFrontmost")
      saveAppName(appName: "coding-environment")
    } else {
      executeCurlCommand(data: "setIsBackground")
      if title == "kitty-lf" {
        print("kitty-lf is frontmost")
        saveAppName(appName: "kitty-lf")
      } else {
        print("The frontmost app is: \(appName), Window title: \(title ?? "Unknown")")
        saveAppName(appName: appName)
      }
    }
  }
}

RunLoop.current.run()
