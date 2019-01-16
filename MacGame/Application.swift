import AppKit

@NSApplicationMain class Application:NSObject, NSApplicationDelegate, NSWindowDelegate {
    func applicationShouldTerminateAfterLastWindowClosed(_:NSApplication) -> Bool { return true }
    
    override init() {
        super.init()
        UserDefaults.standard.set(false, forKey:"NSFullScreenMenuItemEverywhere")
    }
    
    func applicationDidFinishLaunching(_:Notification) {
        Application.view = NSApp.windows.first as? View
    }
    
    func applicationWillTerminate(_:Notification) {
        Application.view.fireSchedule()
    }
}
