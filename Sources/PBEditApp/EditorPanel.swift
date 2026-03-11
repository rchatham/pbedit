import AppKit
import PBEditCore

final class EditorPanel: NSPanel {
    private let textView: NSTextView
    private let scrollView: NSScrollView

    static let shared = EditorPanel()

    private init() {
        scrollView = NSScrollView()
        textView = NSTextView()

        super.init(
            contentRect: NSRect(x: 0, y: 0, width: 500, height: 400),
            styleMask: [.titled, .closable, .resizable, .utilityWindow],
            backing: .buffered,
            defer: false
        )

        title = "Edit Clipboard"
        level = .floating
        isReleasedWhenClosed = false
        center()

        setupUI()
        loadClipboard()
    }

    private func setupUI() {
        let contentView = NSView()
        self.contentView = contentView

        // Toolbar buttons
        let toolbar = NSStackView()
        toolbar.orientation = .horizontal
        toolbar.spacing = 8
        toolbar.translatesAutoresizingMaskIntoConstraints = false

        let saveButton = makeButton(title: "Save", action: #selector(saveAction))
        let cancelButton = makeButton(title: "Cancel", action: #selector(cancelAction))
        let trimButton = makeButton(title: "Trim", action: #selector(trimAction))
        let upperButton = makeButton(title: "Uppercase", action: #selector(upperAction))
        let lowerButton = makeButton(title: "Lowercase", action: #selector(lowerAction))

        saveButton.keyEquivalent = "\r"
        cancelButton.keyEquivalent = "\u{1b}"

        toolbar.addArrangedSubview(saveButton)
        toolbar.addArrangedSubview(cancelButton)
        toolbar.addArrangedSubview(NSBox.verticalSeparator())
        toolbar.addArrangedSubview(trimButton)
        toolbar.addArrangedSubview(upperButton)
        toolbar.addArrangedSubview(lowerButton)
        toolbar.addArrangedSubview(NSView()) // spacer

        // Text view
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.hasVerticalScroller = true
        scrollView.hasHorizontalScroller = false
        scrollView.borderType = .bezelBorder

        textView.isEditable = true
        textView.isSelectable = true
        textView.allowsUndo = true
        textView.isRichText = false
        textView.font = NSFont.monospacedSystemFont(ofSize: 13, weight: .regular)
        textView.isVerticallyResizable = true
        textView.isHorizontallyResizable = false
        textView.textContainer?.widthTracksTextView = true
        textView.autoresizingMask = [.width]
        textView.minSize = NSSize(width: 0, height: 0)
        textView.maxSize = NSSize(width: CGFloat.greatestFiniteMagnitude, height: CGFloat.greatestFiniteMagnitude)

        scrollView.documentView = textView

        contentView.addSubview(toolbar)
        contentView.addSubview(scrollView)

        NSLayoutConstraint.activate([
            toolbar.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            toolbar.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            toolbar.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),

            scrollView.topAnchor.constraint(equalTo: toolbar.bottomAnchor, constant: 8),
            scrollView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            scrollView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -8),
            scrollView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
        ])
    }

    func showPanel() {
        loadClipboard()
        center()
        makeKeyAndOrderFront(nil)
        NSApp.activate(ignoringOtherApps: true)
    }

    private func loadClipboard() {
        let clipboard = Clipboard()
        textView.string = clipboard.read() ?? ""
    }

    private func makeButton(title: String, action: Selector) -> NSButton {
        let button = NSButton(title: title, target: self, action: action)
        button.bezelStyle = .rounded
        return button
    }

    @objc private func saveAction() {
        let clipboard = Clipboard()
        clipboard.write(textView.string)
        orderOut(nil)
    }

    @objc private func cancelAction() {
        orderOut(nil)
    }

    @objc private func trimAction() {
        if let result = try? apply(.trim, to: textView.string) {
            textView.string = result
        }
    }

    @objc private func upperAction() {
        if let result = try? apply(.upper, to: textView.string) {
            textView.string = result
        }
    }

    @objc private func lowerAction() {
        if let result = try? apply(.lower, to: textView.string) {
            textView.string = result
        }
    }
}

private extension NSBox {
    static func verticalSeparator() -> NSBox {
        let separator = NSBox()
        separator.boxType = .separator
        return separator
    }
}
