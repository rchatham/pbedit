import ArgumentParser
import Foundation
import PBEditCore

@main
struct PBEdit: ParsableCommand {
    static let configuration = CommandConfiguration(
        commandName: "pbedit",
        abstract: "Edit macOS clipboard contents from the command line.",
        subcommands: [Get.self, Edit.self, Set.self, Trim.self, Upper.self, Lower.self, Replace.self, App.self],
        defaultSubcommand: Get.self
    )
}

// MARK: - Get (default)

struct Get: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Print clipboard contents to stdout."
    )

    func run() throws {
        let clipboard = Clipboard()
        if let text = clipboard.read() {
            print(text)
        }
    }
}

// MARK: - Edit

struct Edit: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Open clipboard in $EDITOR for editing."
    )

    func run() throws {
        guard let editor = ProcessInfo.processInfo.environment["EDITOR"] else {
            throw ValidationError("$EDITOR is not set. Set it with: export EDITOR=vim")
        }

        let clipboard = Clipboard()
        let currentText = clipboard.read() ?? ""

        let tempDir = FileManager.default.temporaryDirectory
        let tempFile = tempDir.appendingPathComponent("pbedit_\(ProcessInfo.processInfo.processIdentifier).txt")

        try currentText.write(to: tempFile, atomically: true, encoding: .utf8)
        defer { try? FileManager.default.removeItem(at: tempFile) }

        let process = Process()
        process.executableURL = URL(fileURLWithPath: "/usr/bin/env")
        process.arguments = [editor, tempFile.path]
        process.standardInput = FileHandle.standardInput
        process.standardOutput = FileHandle.standardOutput
        process.standardError = FileHandle.standardError

        try process.run()
        process.waitUntilExit()

        guard process.terminationStatus == 0 else {
            throw ValidationError("Editor exited with status \(process.terminationStatus)")
        }

        let editedText = try String(contentsOf: tempFile, encoding: .utf8)
        clipboard.write(editedText)
    }
}

// MARK: - Set

struct Set: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Set clipboard from argument or stdin."
    )

    @Argument(help: "Text to set on the clipboard. Reads from stdin if omitted.")
    var text: [String] = []

    func run() throws {
        let clipboard = Clipboard()
        let value: String

        if !text.isEmpty {
            value = text.joined(separator: " ")
        } else if !isatty(STDIN_FILENO).boolValue {
            // Reading from pipe/stdin
            guard let data = try? FileHandle.standardInput.readToEnd(),
                  let str = String(data: data, encoding: .utf8) else {
                throw ValidationError("Failed to read from stdin")
            }
            value = str
            // Remove trailing newline that shells typically add
            if value.hasSuffix("\n") {
                clipboard.write(String(value.dropLast()))
                return
            }
        } else {
            throw ValidationError("No text provided. Pass text as argument or pipe via stdin.")
        }

        clipboard.write(value)
    }
}

// MARK: - Trim

struct Trim: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Trim whitespace and newlines from clipboard."
    )

    func run() throws {
        let clipboard = Clipboard()
        guard let text = clipboard.read() else { return }
        let result = try apply(.trim, to: text)
        clipboard.write(result)
    }
}

// MARK: - Upper

struct Upper: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Convert clipboard text to uppercase."
    )

    func run() throws {
        let clipboard = Clipboard()
        guard let text = clipboard.read() else { return }
        let result = try apply(.upper, to: text)
        clipboard.write(result)
    }
}

// MARK: - Lower

struct Lower: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Convert clipboard text to lowercase."
    )

    func run() throws {
        let clipboard = Clipboard()
        guard let text = clipboard.read() else { return }
        let result = try apply(.lower, to: text)
        clipboard.write(result)
    }
}

// MARK: - Replace

struct Replace: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Regex find/replace on clipboard text."
    )

    @Argument(help: "Regex pattern to match.")
    var pattern: String

    @Argument(help: "Replacement string.")
    var replacement: String

    func run() throws {
        let clipboard = Clipboard()
        guard let text = clipboard.read() else { return }
        let result = try apply(.replace(pattern: pattern, replacement: replacement), to: text)
        clipboard.write(result)
    }
}

// MARK: - App

struct App: ParsableCommand {
    static let configuration = CommandConfiguration(
        abstract: "Launch the PBEdit menu bar app."
    )

    func run() throws {
        let appLocations = [
            "\(FileManager.default.homeDirectoryForCurrentUser.path)/Applications/PBEdit.app",
            "/Applications/PBEdit.app",
        ]

        for path in appLocations {
            if FileManager.default.fileExists(atPath: path) {
                let process = Process()
                process.executableURL = URL(fileURLWithPath: "/usr/bin/open")
                process.arguments = [path]
                try process.run()
                process.waitUntilExit()
                return
            }
        }

        throw ValidationError("PBEdit.app not found. Install it with: make install-app")
    }
}

// MARK: - Helpers

private extension Int32 {
    var boolValue: Bool { self != 0 }
}
