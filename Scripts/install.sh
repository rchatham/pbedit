#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
PROJECT_DIR="$(dirname "$SCRIPT_DIR")"

cd "$PROJECT_DIR"

echo "Building pbedit..."
make build

echo ""
echo "Installing CLI tool..."
make install-cli

echo ""
echo "Building and installing menu bar app..."
make install-app

echo ""
echo "Done! You can now use:"
echo "  pbedit          - CLI clipboard editor"
echo "  PBEdit.app      - Menu bar app (in ~/Applications)"
