#!/bin/bash
# Check if Typst is installed and provide installation instructions if not
# Usage: ./check_install.sh

if command -v typst &> /dev/null; then
    echo "Typst is installed:"
    typst --version
    echo ""
    echo "Available fonts:"
    typst fonts | head -20
    echo "..."
else
    echo "Typst is not installed."
    echo ""
    echo "Installation options:"
    echo ""

    # Detect OS and provide specific instructions
    if [[ -f /etc/arch-release ]]; then
        echo "Arch Linux:"
        echo "  sudo pacman -S typst"
    elif [[ -f /etc/debian_version ]]; then
        echo "Debian/Ubuntu:"
        echo "  cargo install typst-cli"
        echo "  # Or download from https://github.com/typst/typst/releases"
    elif [[ "$(uname)" == "Darwin" ]]; then
        echo "macOS:"
        echo "  brew install typst"
    else
        echo "General (requires Rust/Cargo):"
        echo "  cargo install typst-cli"
    fi

    echo ""
    echo "Binary download (all platforms):"
    echo "  https://github.com/typst/typst/releases"

    exit 1
fi
