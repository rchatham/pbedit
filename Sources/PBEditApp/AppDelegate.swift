import AppKit

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var hotKeyManager: HotKeyManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        hotKeyManager = HotKeyManager { [weak self] in
            self?.openEditor()
        }
        hotKeyManager?.register()
    }

    func applicationWillTerminate(_ notification: Notification) {
        hotKeyManager?.unregister()
    }

    private func openEditor() {
        EditorPanel.shared.showPanel()
    }
}
