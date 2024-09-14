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

func storeFocusedGlobalAppName(appName: String) {
  let filePath = "/tmp/focused_global_app.txt"
  do {
    try appName.write(toFile: filePath, atomically: true, encoding: .utf8)
  } catch {
    print("Failed to write app name to file: \(error)")
  }
}

func storeFocusedWorkspaceAppName(appName: String) {
  let filePath = "/tmp/focused_workspace_app.txt"
  do {
    try appName.write(toFile: filePath, atomically: true, encoding: .utf8)
  } catch {
    print("Failed to write app name to file: \(error)")
  }
}

func getCurrentWorkspace() -> String? {
  let filePath = "/tmp/current_workspace"
  do {
    return try String(contentsOfFile: filePath, encoding: .utf8).trimmingCharacters(
      in: .whitespacesAndNewlines)
  } catch {
    print("Failed to read current workspace from file: \(error)")
    return nil
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

    if title?.hasPrefix("lazygit") == true {
      executeCurlCommand(data: "setKittyLazygitFocused")
      storeFocusedGlobalAppName(appName: "kitty-lazygit")
      storeFocusedWorkspaceAppName(appName: "kitty-lazygit")
    } else if title == "kitty-lf" {
      executeCurlCommand(data: "setDefocused")
      storeFocusedGlobalAppName(appName: "kitty-lf")
    } else if appName == "kitty" {
      if getCurrentWorkspace() != "GitKraken" {
        executeCurlCommand(data: "setKittyMainFocused")
        storeFocusedGlobalAppName(appName: "kitty-main")
        storeFocusedWorkspaceAppName(appName: "kitty-main")
      }
      // } else if appName == "Code" {
    } else if appName == "Cursor" {
      executeCurlCommand(data: "setVscodeFocused")
      storeFocusedGlobalAppName(appName: "vscode")
      storeFocusedWorkspaceAppName(appName: "vscode")
    } else if appName == "Electron" {
      // We need to ignore the line window
    } else {
      executeCurlCommand(data: "setDefocused")
      storeFocusedGlobalAppName(appName: appName)
    }
  }
}

RunLoop.current.run()
