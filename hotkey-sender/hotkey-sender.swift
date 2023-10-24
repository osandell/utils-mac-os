import AppKit
import CoreGraphics
import Darwin
import Foundation

var keepRunning = true
var currentBundleIdentifier: String? = nil
let workspace = NSWorkspace.shared
let fileManager = FileManager.default
let pipePath = "/tmp/keyPipe"
var primarySpecialWorkspace: pid_t?
var secondarySpecialWorkspace: pid_t?

func checkTerminalInTitle(forProcessIdentifier processIdentifier: pid_t) -> Bool {
  let app = AXUIElementCreateApplication(processIdentifier)
  var frontWindow: CFTypeRef?
  var title: CFTypeRef?

  let err1 = AXUIElementCopyAttributeValue(
    app, kAXFocusedWindowAttribute as CFString, &frontWindow)

  if err1 == .success {
    guard let frontWindowElement = frontWindow as! AXUIElement? else {
      return false
    }

    let err2 = AXUIElementCopyAttributeValue(
      frontWindowElement, kAXTitleAttribute as CFString, &title)
    if err2 == .success, let titleStr = title as? String {
      return titleStr.contains("(Terminal)")
    }
  }
  print("err1: \(err1)")
  return false
}

func performAction(action: String) {

  switch action {

  case "set-primary-special-workspace":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      primarySpecialWorkspace = frontmostApp.processIdentifier
    }

  case "set-secondary-special-workspace":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      secondarySpecialWorkspace = frontmostApp.processIdentifier
    }

  case "switch-to-primary-special-workspace":
    guard let primarySpecialWorkspace = primarySpecialWorkspace else {
      break
    }
    if let app = NSRunningApplication(processIdentifier: primarySpecialWorkspace) {
      app.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
    } else {
      print("No application found with process identifier \(primarySpecialWorkspace)")
    }

  case "switch-to-secondary-special-workspace":
    guard let secondarySpecialWorkspace = secondarySpecialWorkspace else {
      break
    }
    if let app = NSRunningApplication(processIdentifier: secondarySpecialWorkspace) {
      app.activate(options: [.activateAllWindows, .activateIgnoringOtherApps])
    } else {
      print("No application found with process identifier \(secondarySpecialWorkspace)")
    }

  case "vscode-last-tab":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      let isTerminalInTitle = checkTerminalInTitle(
        forProcessIdentifier: frontmostApp.processIdentifier)
      if isTerminalInTitle == true {
        sendKeystroke(
          keyCode: keyMap["insert"]!, modifiers: [.maskControl, .maskAlternate])
      } else {
        sendKeystroke(
          keyCode: keyMap["insert"]!, modifiers: [.maskControl, .maskShift, .maskAlternate])
        sendKeystroke(
          keyCode: keyMap["enter"]!, modifiers: [])
      }
    }

  case "vscode-enlarge-shrink":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      let isTerminalInTitle = checkTerminalInTitle(
        forProcessIdentifier: frontmostApp.processIdentifier)
      if isTerminalInTitle == true {
        sendKeystroke(
          keyCode: keyMap["m"]!, modifiers: [.maskControl, .maskShift, .maskAlternate])
      } else {
        sendKeystroke(
          keyCode: keyMap["t"]!, modifiers: [.maskControl, .maskAlternate])
        sendKeystroke(
          keyCode: keyMap["t"]!, modifiers: [.maskControl, .maskShift, .maskAlternate])
        Thread.sleep(forTimeInterval: 0.05)
        sendKeystroke(
          keyCode: keyMap["d"]!, modifiers: [.maskControl, .maskAlternate])
      }
    }

  case "vscode-command-h":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      let isTerminalInTitle = checkTerminalInTitle(
        forProcessIdentifier: frontmostApp.processIdentifier)
      if isTerminalInTitle == true {
        sendKeystroke(
          keyCode: keyMap["r"]!, modifiers: [.maskControl])  // History back
      } else {
        sendKeystroke(
          keyCode: keyMap["w"]!, modifiers: [.maskShift, .maskAlternate])  // Console log with variable
      }
    }

  case "vscode-command-c":
    if let frontmostApp = NSWorkspace.shared.frontmostApplication {
      let isTerminalInTitle = checkTerminalInTitle(
        forProcessIdentifier: frontmostApp.processIdentifier)
      if isTerminalInTitle == true {

        // Clear terminal
        sendKeystroke(
          keyCode: keyMap["u"]!, modifiers: [.maskControl])
        sendKeystroke(
          keyCode: keyMap["k"]!, modifiers: [.maskCommand])
        sendKeystroke(
          keyCode: keyMap["enter"]!, modifiers: [])
      } else {

        // Show hover popup
        sendKeystroke(
          keyCode: keyMap["k"]!, modifiers: [.maskCommand])
        sendKeystroke(
          keyCode: keyMap["i"]!, modifiers: [.maskCommand])
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
}

let dispatchQueue = DispatchQueue(label: "fileReader")
dispatchQueue.async {
  while keepRunning {
    if let reader = FileHandle(forReadingAtPath: "/tmp/keyPipe") {
      if let input = String(data: reader.readDataToEndOfFile(), encoding: .utf8)?
        .trimmingCharacters(
          in: .whitespacesAndNewlines)
      {
        performAction(action: input)
      }
      reader.closeFile()
    }
  }
}

if !fileManager.fileExists(atPath: pipePath) {
  mkfifo(pipePath, 0o600)
}

// SIGINT handling
signal(SIGINT) { _ in keepRunning = false }

let modMap: [String: CGEventFlags] = [
  "shift": .maskShift,
  "control": .maskControl,
  "command": .maskCommand,
  "option": .maskAlternate,
]

let keyMap: [String: CGKeyCode] = [
  "a": 0x00,
  "s": 0x01,
  "d": 0x02,
  "f": 0x03,
  "h": 0x04,
  "g": 0x05,
  "z": 0x06,
  "x": 0x07,
  "c": 0x08,
  "v": 0x09,
  "b": 0x0B,
  "q": 0x0C,
  "w": 0x0D,
  "e": 0x0E,
  "r": 0x0F,
  "y": 0x10,
  "t": 0x11,
  "1": 0x12,
  "2": 0x13,
  "3": 0x14,
  "4": 0x15,
  "6": 0x16,
  "5": 0x17,
  "=": 0x18,
  "9": 0x19,
  "7": 0x1A,
  "-": 0x1B,
  "8": 0x1C,
  "0": 0x1D,
  "]": 0x1E,
  "o": 0x1F,
  "u": 0x20,
  "[": 0x21,
  "i": 0x22,
  "p": 0x23,
  "l": 0x25,
  "j": 0x26,
  "’": 0x27,
  "k": 0x28,
  ";": 0x29,
  "\\": 0x2A,
  ",": 0x2B,
  "/": 0x2C,
  "n": 0x2D,
  "m": 0x2E,
  ".": 0x2F,
  "space": 0x31,
  "`": 0x32,
  "delete": 0x33,
  "enter": 0x24,
  "tab": 0x30,
  "escape": 0x35,
  "command": 0x37,
  "shift": 0x38,
  "capslock": 0x39,
  "option": 0x3A,
  "control": 0x3B,
  "rightShift": 0x3C,
  "rightOption": 0x3D,
  "rightControl": 0x3E,
  "function": 0x3F,
  "f17": 0x40,
  "volumeUp": 0x48,
  "volumeDown": 0x49,
  "mute": 0x4A,
  "f18": 0x4F,
  "f19": 0x50,
  "f20": 0x5A,
  "f5": 0x60,
  "f6": 0x61,
  "f7": 0x62,
  "f3": 0x63,
  "f8": 0x64,
  "f9": 0x65,
  "f11": 0x67,
  "f13": 0x69,
  "f16": 0x6A,
  "f14": 0x6B,
  "f10": 0x6D,
  "f12": 0x6F,
  "f15": 0x71,
  "insert": 0x72,
  "home": 0x73,
  "pgup": 0x74,
  "forwardDelete": 0x75,
  "f4": 0x76,
  "end": 0x77,
  "f2": 0x78,
  "pgdown": 0x79,
  "f1": 0x7A,
  "left": 0x7B,
  "right": 0x7C,
  "down": 0x7D,
  "up": 0x7E,

]

@objc class FrontmostAppObserver: NSObject {
  @objc func frontmostAppChanged(_ notification: Notification) {
    if let appInfo = notification.userInfo,
      let app = appInfo[NSWorkspace.applicationUserInfoKey] as? NSRunningApplication,
      let bundleIdentifier = app.bundleIdentifier
    {
      currentBundleIdentifier = bundleIdentifier
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
  print("Received SIGINT")
  keepRunning = false
  exit(0)
}
signalSource.resume()

RunLoop.main.run()
