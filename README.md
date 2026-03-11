# pbedit

A macOS clipboard manipulation utility with both CLI and menu bar interfaces.

## Features

- **CLI Tool**: Read, write, and transform clipboard contents from the terminal
- **Menu Bar App**: Quick access editor with global hotkey (Cmd+Shift+E)
- **Transforms**: Trim whitespace, change case, regex find/replace

## Installation

### Build from source

```bash
# Clone the repository
git clone https://github.com/rchatham/pbedit.git
cd pbedit

# Build and install both CLI and app
make install

# Or install separately
make install-cli   # Installs to /usr/local/bin (requires sudo)
make install-app   # Installs to ~/Applications
```

### Man page (optional)

```bash
sudo cp man/pbedit.1 /usr/local/share/man/man1/
man pbedit
```

## CLI Usage

### Basic Commands

```bash
# Get clipboard contents (default command)
pbedit
pbedit get

# Set clipboard from argument
pbedit set "Hello, World!"

# Set clipboard from stdin (pipe)
echo "piped content" | pbedit set
cat file.txt | pbedit set

# Edit clipboard in $EDITOR
export EDITOR=vim
pbedit edit
```

### Transforms

```bash
# Trim whitespace
pbedit trim

# Convert to uppercase/lowercase
pbedit upper
pbedit lower

# Regex find/replace
pbedit replace "pattern" "replacement"
pbedit replace "(\w+)@(\w+)" "$1 at $2"
```

### Launch Menu Bar App

```bash
pbedit app
```

## Menu Bar App

The menu bar app provides:

- **Clipboard preview** in the menu
- **Global hotkey** (Cmd+Shift+E) to open editor panel
- **One-click transforms**: Trim, Uppercase, Lowercase
- **Floating editor** for quick clipboard editing

### First Launch

On first launch, macOS may require accessibility permissions for the global hotkey to work:

1. Open System Settings > Privacy & Security > Accessibility
2. Add PBEdit.app to the allowed applications

## Development

### Build

```bash
swift build              # Debug build
swift build -c release   # Release build
```

### Test

```bash
swift test
```

### Project Structure

```
pbedit/
├── Sources/
│   ├── pbedit/          # CLI executable
│   ├── PBEditApp/       # Menu bar app
│   └── PBEditCore/      # Shared library
├── Tests/
│   └── PBEditCoreTests/ # Unit tests
├── Resources/
│   └── Info.plist       # App bundle info
└── man/
    └── pbedit.1         # Man page
```

## Requirements

- macOS 13.0 (Ventura) or later
- Swift 5.9+

## License

MIT
