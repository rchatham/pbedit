import SwiftUI
import PBEditCore
import ServiceManagement

@main
struct PBEditApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @State private var clipboardPreview: String = ""
    @State private var launchAtLogin: Bool = SMAppService.mainApp.status == .enabled

    var body: some Scene {
        MenuBarExtra("PBEdit", systemImage: "doc.on.clipboard") {
            Text(clipboardPreview)
                .font(.caption)
                .foregroundColor(.secondary)
                .lineLimit(1)
                .onAppear { refreshPreview() }

            Divider()

            Button("Edit Clipboard...") {
                EditorPanel.shared.showPanel()
            }
            .keyboardShortcut("e", modifiers: [.command, .shift])

            Divider()

            Button("Trim") {
                applyTransform(.trim)
            }
            Button("Uppercase") {
                applyTransform(.upper)
            }
            Button("Lowercase") {
                applyTransform(.lower)
            }

            Divider()

            Toggle("Launch at Login", isOn: $launchAtLogin)
                .onChange(of: launchAtLogin) { newValue in
                    do {
                        if newValue {
                            try SMAppService.mainApp.register()
                        } else {
                            try SMAppService.mainApp.unregister()
                        }
                    } catch {
                        launchAtLogin = !newValue
                    }
                }

            Divider()

            Button("Quit PBEdit") {
                NSApplication.shared.terminate(nil)
            }
            .keyboardShortcut("q")
        }
    }

    private func refreshPreview() {
        let clipboard = Clipboard()
        if let text = clipboard.read() {
            let trimmed = text.trimmingCharacters(in: .whitespacesAndNewlines)
            if trimmed.count > 50 {
                clipboardPreview = String(trimmed.prefix(50)) + "..."
            } else {
                clipboardPreview = trimmed
            }
        } else {
            clipboardPreview = "(clipboard empty)"
        }
    }

    private func applyTransform(_ transform: Transform) {
        let clipboard = Clipboard()
        guard let text = clipboard.read() else { return }
        if let result = try? PBEditCore.apply(transform, to: text) {
            clipboard.write(result)
        }
    }
}
