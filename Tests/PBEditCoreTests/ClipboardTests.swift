import Foundation
import Testing
@testable import PBEditCore

@Suite("Clipboard Tests", .serialized)
struct ClipboardTests {

    @Test("Clipboard can write and read text")
    func writeAndRead() {
        let clipboard = Clipboard()
        let testText = "test clipboard content \(UUID())"

        clipboard.write(testText)
        let result = clipboard.read()

        #expect(result == testText)
    }

    @Test("Clipboard handles multiline text")
    func multilineText() {
        let clipboard = Clipboard()
        let testText = """
        Line 1
        Line 2
        Line 3
        """

        clipboard.write(testText)
        let result = clipboard.read()

        #expect(result == testText)
    }

    @Test("Clipboard handles unicode")
    func unicodeText() {
        let clipboard = Clipboard()
        let testText = "Hello, World!"

        clipboard.write(testText)
        let result = clipboard.read()

        #expect(result == testText)
    }

    @Test("Clipboard handles empty string")
    func emptyString() {
        let clipboard = Clipboard()

        clipboard.write("")
        let result = clipboard.read()

        #expect(result == "")
    }

    @Test("Clipboard clear removes content")
    func clearClipboard() {
        let clipboard = Clipboard()

        clipboard.write("some content")
        clipboard.clear()
        let result = clipboard.read()

        #expect(result == nil)
    }

    @Test("Clipboard handles special characters")
    func specialCharacters() {
        let clipboard = Clipboard()
        let testText = "Tab:\tNewline:\nQuote:\"Backslash:\\"

        clipboard.write(testText)
        let result = clipboard.read()

        #expect(result == testText)
    }

    @Test("Clipboard overwrites previous content")
    func overwriteContent() {
        let clipboard = Clipboard()

        clipboard.write("first")
        clipboard.write("second")
        let result = clipboard.read()

        #expect(result == "second")
    }
}
