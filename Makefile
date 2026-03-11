.PHONY: build build-app install-cli install-app install-man install clean test

BUILD_DIR := $(shell swift build -c release --show-bin-path 2>/dev/null || echo .build/release)
APP_BUNDLE := build/PBEdit.app

build:
	swift build -c release

install-cli: build
	@mkdir -p /usr/local/bin
	sudo cp "$$(swift build -c release --show-bin-path)/pbedit" /usr/local/bin/pbedit
	@echo "Installed pbedit to /usr/local/bin/pbedit"

build-app: build
	@mkdir -p $(APP_BUNDLE)/Contents/MacOS
	@mkdir -p $(APP_BUNDLE)/Contents/Resources
	cp "$$(swift build -c release --show-bin-path)/PBEditApp" $(APP_BUNDLE)/Contents/MacOS/PBEditApp
	cp Resources/Info.plist $(APP_BUNDLE)/Contents/Info.plist
	codesign --force --deep --sign - $(APP_BUNDLE)
	@echo "Built $(APP_BUNDLE)"

install-app: build-app
	@mkdir -p ~/Applications
	cp -R $(APP_BUNDLE) ~/Applications/PBEdit.app
	xattr -cr ~/Applications/PBEdit.app
	codesign --force --deep --sign - ~/Applications/PBEdit.app
	@echo "Installed PBEdit.app to ~/Applications/"

install-man:
	@mkdir -p /usr/local/share/man/man1
	sudo cp man/pbedit.1 /usr/local/share/man/man1/pbedit.1
	@echo "Installed man page to /usr/local/share/man/man1/pbedit.1"

install: install-cli install-app

test:
	swift test

clean:
	swift package clean
	rm -rf build
