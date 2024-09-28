import AVFoundation
import AppKit
import CoreGraphics
import Darwin
import Foundation

let fileManager = FileManager.default
let pipePath = "/tmp/keyPipe"
let workspace = NSWorkspace.shared

var audioPlayer: AVAudioPlayer?
var currentBundleIdentifier: String? = nil
var keepRunning = true
var primarySpecialWorkspace: pid_t?
var secondarySpecialWorkspace: pid_t?
var tertiarySpecialWorkspace: pid_t?

// Logging function
func logMessage(_ message: String) {
  let dateFormatter = DateFormatter()
  dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
  let timestamp = dateFormatter.string(from: Date())
  print("[\(timestamp)] \(message)")
}

func playSound(fileName: String) {
  guard let url = Bundle.main.url(forResource: fileName, withExtension: "mp3") else {
    logMessage("Sound file not found for \(fileName).")
    return
  }

  do {
    audioPlayer = try AVAudioPlayer(contentsOf: url)
    audioPlayer?.play()
    logMessage("Playing sound: \(fileName).")
  } catch {
    logMessage("Could not load or play sound file: \(error).")
  }
}

func checkChatInTitle(forProcessIdentifier processIdentifier: pid_t) -> Bool {
  let app = AXUIElementCreateApplication(processIdentifier)
  var frontWindow: CFTypeRef?
  var title: CFTypeRef?

  let err1 = AXUIElementCopyAttributeValue(app, kAXFocusedWindowAttribute as CFString, &frontWindow)

  if err1 == .success {
    guard let frontWindowElement = frontWindow as! AXUIElement? else {
      logMessage("Failed to get front window element for process ID \(processIdentifier).")
      return false
    }

    let err2 = AXUIElementCopyAttributeValue(
      frontWindowElement, kAXTitleAttribute as CFString, &title)
    if err2 == .success, let titleStr = title as? String {
      return titleStr.contains("(Chat)")
    } else {
      logMessage(
        "Failed to get window title or title does not contain '(Chat)' for process ID \(processIdentifier)."
      )
    }
  }
  logMessage(
    "Error accessing focused window attribute for process ID \(processIdentifier): \(err1).")
  return false
}

func checkLfInTitle(forProcessIdentifier processIdentifier: pid_t) -> Bool {
  let app = AXUIElementCreateApplication(processIdentifier)
  var frontWindow: CFTypeRef?
  var title: CFTypeRef?

  let err1 = AXUIElementCopyAttributeValue(app, kAXFocusedWindowAttribute as CFString, &frontWindow)

  if err1 == .success {
    guard let frontWindowElement = frontWindow as! AXUIElement? else {
      logMessage("Failed to get front window element for process ID \(processIdentifier).")
      return false
    }

    let err2 = AXUIElementCopyAttributeValue(
      frontWindowElement, kAXTitleAttribute as CFString, &title)
    if err2 == .success, let titleStr = title as? String {
      return titleStr.contains("lf")
    } else {
      logMessage(
        "Failed to get window title or title does not contain 'lf' for process ID \(processIdentifier)."
      )
    }
  }
  logMessage(
    "Error accessing focused window attribute for process ID \(processIdentifier): \(err1).")
  return false
}

func performAction(action: String) {
  let components = action.split(separator: " ", maxSplits: 1, omittingEmptySubsequences: true)

  guard let command = components.first else { return }

  switch command {

  case "set-primary-special-workspace":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      primarySpecialWorkspace = frontmostApp.processIdentifier
      playSound(fileName: "doorknob-click")
    }

  case "set-secondary-special-workspace":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      secondarySpecialWorkspace = frontmostApp.processIdentifier
      playSound(fileName: "doorknob-click")
    }

  case "set-tertiary-special-workspace":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      tertiarySpecialWorkspace = frontmostApp.processIdentifier
      playSound(fileName: "doorknob-click")
    }

  case "switch-to-primary-special-workspace":
    guard let primarySpecialWorkspace = primarySpecialWorkspace else {
      break
    }
    if let app = NSRunningApplication(processIdentifier: primarySpecialWorkspace) {
      app.activate(options: [.activateAllWindows])  // Removed deprecated option
    } else {
      print("No application found with process identifier \(primarySpecialWorkspace)")
    }

  case "switch-to-secondary-special-workspace":
    guard let secondarySpecialWorkspace = secondarySpecialWorkspace else {
      break
    }
    if let app = NSRunningApplication(processIdentifier: secondarySpecialWorkspace) {
      app.activate(options: [.activateAllWindows])  // Removed deprecated option
    } else {
      print("No application found with process identifier \(secondarySpecialWorkspace)")
    }

  case "switch-to-tertiary-special-workspace":
    guard let tertiarySpecialWorkspace = tertiarySpecialWorkspace else {
      break
    }
    if let app = NSRunningApplication(processIdentifier: tertiarySpecialWorkspace) {
      app.activate(options: [.activateAllWindows])  // Removed deprecated option
    } else {
      print("No application found with process identifier \(tertiarySpecialWorkspace)")
    }

  case "vscode-last-tab":
    sendKeystroke(
      keyCode: keyMap["insert"]!.keyCode, modifiers: [.maskControl, .maskShift, .maskAlternate])
    sendKeystroke(
      keyCode: keyMap["enter"]!.keyCode, modifiers: [])

  case "vscode-enlarge-shrink":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      let isChatInTitle = checkChatInTitle(
        forProcessIdentifier: frontmostApp.processIdentifier)
      if isChatInTitle == true {
        // Make POST request to localhost:57321
        let url = URL(string: "http://localhost:57321")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "toCompactScreen".data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          if let error = error {
            logMessage("Error making POST request: \(error.localizedDescription)")
          } else if let httpResponse = response as? HTTPURLResponse {
            logMessage("POST request completed with status code: \(httpResponse.statusCode)")
          }
        }
        task.resume()
        sendKeystroke(
          keyCode: keyMap["l"]!.keyCode, modifiers: [.maskCommand])

      } else {
        // Make POST request to localhost:57321
        let url = URL(string: "http://localhost:57321")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.httpBody = "toFullscreen".data(using: .utf8)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          if let error = error {
            logMessage("Error making POST request: \(error.localizedDescription)")
          } else if let httpResponse = response as? HTTPURLResponse {
            logMessage("POST request completed with status code: \(httpResponse.statusCode)")
          }
        }
        task.resume()
        sendKeystroke(
          keyCode: keyMap["l"]!.keyCode, modifiers: [.maskCommand])
      }
    }

  case "vscode-command-h":
    sendKeystroke(keyCode: keyMap["w"]!.keyCode, modifiers: [.maskShift, .maskAlternate])  // Console log with variable

  case "vscode-command-c":
    // Show hover popup
    sendKeystroke(keyCode: keyMap["k"]!.keyCode, modifiers: [.maskCommand])
    sendKeystroke(keyCode: keyMap["i"]!.keyCode, modifiers: [.maskCommand])

  case "command-r":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      let isLfInTitle = checkLfInTitle(forProcessIdentifier: frontmostApp.processIdentifier)
      if isLfInTitle {
        // Cut (lf can't handle command mappings so we need to use control)
        sendKeystroke(keyCode: keyMap["r"]!.keyCode, modifiers: [.maskControl])
      } else {
        // Cut
        sendKeystroke(keyCode: keyMap["x"]!.keyCode, modifiers: [.maskCommand])
      }
    }

  case "command-s":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      let isLfInTitle = checkLfInTitle(forProcessIdentifier: frontmostApp.processIdentifier)
      if isLfInTitle {
        // Copy (lf can't handle command mappings so we need to use control)
        sendKeystroke(keyCode: keyMap["s"]!.keyCode, modifiers: [.maskControl])
      } else {
        // Copy
        sendKeystroke(keyCode: keyMap["c"]!.keyCode, modifiers: [.maskCommand])
      }
    }

  case "command-t":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      let isLfInTitle = checkLfInTitle(forProcessIdentifier: frontmostApp.processIdentifier)
      if isLfInTitle {
        // Paste (lf can't handle command mappings so we need to use control)
        sendKeystroke(keyCode: keyMap["t"]!.keyCode, modifiers: [.maskControl])
      } else {
        // Paste
        sendKeystroke(keyCode: keyMap["v"]!.keyCode, modifiers: [.maskCommand])
      }
    }

  case "paste":
    if components.count > 1 {
      let textToType = components[1]
      for character in textToType {
        print("Character: \(character)")

        let charString = String(character)

        if charString == "~" {
          let keyCode = keyMap["~"]!
          // Send the ~ character using maskAlternate and then press space
          sendKeystroke(keyCode: keyCode.keyCode, modifiers: keyCode.modifiers)
          sendKeystroke(keyCode: keyMap[" "]!.keyCode, modifiers: [])  // Press space
        } else if let keyCode = keyMap[charString] {
          sendKeystroke(keyCode: keyCode.keyCode, modifiers: keyCode.modifiers)
        } else {
          logMessage("Key code not found for character: \(charString)")
        }
      }
    }

  default:
    print("Unknown action: \(action)")
  }
}

func sendKeystroke(keyCode: CGKeyCode, modifiers: CGEventFlags) {
  let eventSource = CGEventSource(stateID: CGEventSourceStateID.hidSystemState)
  if let down = CGEvent(keyboardEventSource: eventSource, virtualKey: keyCode, keyDown: true) {
    down.flags = modifiers
    down.post(tap: CGEventTapLocation.cghidEventTap)
  }
  if let up = CGEvent(keyboardEventSource: eventSource, virtualKey: keyCode, keyDown: false) {
    up.flags = modifiers
    up.post(tap: CGEventTapLocation.cghidEventTap)
  }
  // Log keyCode and modifiers in hexadecimal format
  logMessage(
    "Sent keystroke: keyCode=0x\(String(keyCode, radix: 16).uppercased()), modifiers=0x\(String(modifiers.rawValue, radix: 16).uppercased())."
  )
}

let dispatchQueue = DispatchQueue(label: "fileReader")
dispatchQueue.async {
  while keepRunning {
    if let reader = FileHandle(forReadingAtPath: pipePath) {
      let inputData = reader.readDataToEndOfFile()
      if let input = String(data: inputData, encoding: .utf8)?.trimmingCharacters(
        in: .whitespacesAndNewlines), !input.isEmpty
      {
        logMessage("Received input from pipe: \(input)")
        performAction(action: input)
      } else {
        logMessage("No input received or input is empty.")
      }
      reader.closeFile()
    } else {
      logMessage("Failed to open pipe for reading at \(pipePath).")
    }
  }
}

if !fileManager.fileExists(atPath: pipePath) {
  mkfifo(pipePath, 0o600)
  logMessage("Created named pipe at \(pipePath).")
}

// SIGINT handling
signal(SIGINT) { _ in keepRunning = false }

let modMap: [String: CGEventFlags] = [
  "shift": .maskShift,
  "control": .maskControl,
  "command": .maskCommand,
  "option": .maskAlternate,
]

let keyMap: [String: (keyCode: CGKeyCode, modifiers: CGEventFlags)] = [
  "a": (0x00, []), "A": (0x00, .maskShift),
  "s": (0x01, []), "S": (0x01, .maskShift),
  "d": (0x02, []), "D": (0x02, .maskShift),
  "f": (0x03, []), "F": (0x03, .maskShift),
  "h": (0x04, []), "H": (0x04, .maskShift),
  "g": (0x05, []), "G": (0x05, .maskShift),
  "z": (0x06, []), "Z": (0x06, .maskShift),
  "x": (0x07, []), "X": (0x07, .maskShift),
  "c": (0x08, []), "C": (0x08, .maskShift),
  "v": (0x09, []), "V": (0x09, .maskShift),
  "b": (0x0B, []), "B": (0x0B, .maskShift),
  "q": (0x0C, []), "Q": (0x0C, .maskShift),
  "w": (0x0D, []), "W": (0x0D, .maskShift),
  "e": (0x0E, []), "E": (0x0E, .maskShift),
  "r": (0x0F, []), "R": (0x0F, .maskShift),
  "y": (0x10, []), "Y": (0x10, .maskShift),
  "t": (0x11, []), "T": (0x11, .maskShift),
  "u": (0x20, []), "U": (0x20, .maskShift),
  "i": (0x22, []), "I": (0x22, .maskShift),
  "o": (0x1F, []), "O": (0x1F, .maskShift),
  "p": (0x23, []), "P": (0x23, .maskShift),
  "l": (0x25, []), "L": (0x25, .maskShift),
  "j": (0x26, []), "J": (0x26, .maskShift),
  "k": (0x28, []), "K": (0x28, .maskShift),
  "n": (0x2D, []), "N": (0x2D, .maskShift),
  "m": (0x2E, []), "M": (0x2E, .maskShift),
  "ö": (0x29, []), "Ö": (0x29, .maskShift),
  "å": (0x21, []), "Å": (0x21, .maskShift),
  "ä": (0x27, []), "Ä": (0x27, .maskShift),
  "1": (0x12, []), "!": (0x12, .maskShift),
  "2": (0x13, []), "\"": (0x13, .maskShift),
  "@": (0x13, .maskAlternate),
  "3": (0x14, []), "#": (0x14, .maskShift),
  "4": (0x15, []), "€": (0x15, .maskShift),
  "$": (0x15, .maskAlternate),
  "5": (0x17, []), "%": (0x17, .maskShift),
  "∞": (0x17, .maskAlternate),
  "6": (0x16, []), "&": (0x16, .maskShift),
  "7": (0x1A, []), "/": (0x1A, .maskShift),
  "{": (0x1A, .maskAlternate),
  "8": (0x1C, []), "(": (0x1C, .maskShift),
  "9": (0x19, []), ")": (0x19, .maskShift),
  "0": (0x1D, []), "=": (0x1D, .maskShift),
  "}": (0x1D, .maskAlternate),
  "+": (0x1B, []), "?": (0x1B, .maskShift),
  "\\": (0x1B, .maskAlternate),
  "[": (0x18, []), "`": (0x18, .maskShift),
  "]": (0x1E, []), "^": (0x1E, .maskShift),
  "~": (0x1E, .maskAlternate),
  "'": (0x2A, []), "*": (0x2A, .maskShift),
  "™": (0x2A, .maskAlternate),
  ",": (0x2B, []), ";": (0x2B, .maskShift),
  ".": (0x2F, []), ":": (0x2F, .maskShift),
  "-": (0x2C, []), "_": (0x2C, .maskShift),
  "<": (0x32, []), ">": (0x32, .maskShift),
  "|": (0x32, .maskAlternate),
  "§": (0x0A, []), "°": (0x0A, .maskShift),
  " ": (0x33, []),
]

@objc class FrontmostAppObserver: NSObject {
  @objc func frontmostAppChanged(_ notification: Notification) {
    if let appInfo = notification.userInfo,
      let app = appInfo[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
      let bundleIdentifier = app.bundleIdentifier
    {
      currentBundleIdentifier = bundleIdentifier
      logMessage("Frontmost application changed: \(bundleIdentifier).")
    }
  }
}

let observer = FrontmostAppObserver()
workspace.notificationCenter.addObserver(
  observer,
  selector: #selector(FrontmostAppObserver.frontmostAppChanged(_:)),
  name: NSWorkspace.didActivateApplicationNotification,
  object: nil
)

let signalSource = DispatchSource.makeSignalSource(signal: SIGINT, queue: DispatchQueue.main)
signalSource.setEventHandler {
  logMessage("SIGINT signal source event handler triggered.")
  keepRunning = false
  exit(0)
}
signalSource.resume()

RunLoop.main.run()
