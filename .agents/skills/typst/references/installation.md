# Typst Installation

## Arch Linux
```bash
sudo pacman -S typst
```

## macOS
```bash
# Homebrew
brew install typst

# MacPorts
sudo port install typst
```

## Ubuntu/Debian
```bash
# Via Cargo (requires Rust)
cargo install typst-cli

# Or download binary
curl -LO https://github.com/typst/typst/releases/latest/download/typst-x86_64-unknown-linux-gnu.tar.xz
tar -xf typst-x86_64-unknown-linux-gnu.tar.xz
sudo mv typst-x86_64-unknown-linux-gnu/typst /usr/local/bin/
```

## Windows
```powershell
# Winget
winget install typst

# Scoop
scoop install typst

# Chocolatey
choco install typst
```

## From Source
```bash
# Install Rust if needed
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# Install Typst
cargo install typst-cli
```

## Verify Installation
```bash
typst --version
typst fonts
```

## CLI Commands

### Basic
```bash
typst compile document.typ           # Compile to PDF
typst compile document.typ output.pdf # Custom output name
typst watch document.typ             # Auto-recompile on changes
typst fonts                          # List available fonts
```

### Advanced Options
```bash
typst compile --root ./project document.typ     # Specify root directory
typst compile --font-path ./fonts document.typ  # Add font search path
typst compile --input version=1.0 document.typ  # Set input variables
```
