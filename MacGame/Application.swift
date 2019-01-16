import AppKit

@NSApplicationMain class Application:NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    
    func applicationDidFinishLaunching(_:Notification) {
        UserDefaults.standard.set(false, forKey:"NSFullScreenMenuItemEverywhere")
    }
}
