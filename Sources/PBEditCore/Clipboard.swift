import AppKit

public struct Clipboard {
    public init() {}

    public func read() -> String? {
        NSPasteboard.general.string(forType: .string)
    }

    public func write(_ string: String) {
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(string, forType: .string)
    }

    public func clear() {
        NSPasteboard.general.clearContents()
    }
}
