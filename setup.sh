#!/bin/bash
# Symlink dotfiles to home directory
# Run from the .dotfiles directory: ./setup.sh

DOTFILES="$(cd "$(dirname "$0")" && pwd)"
HOME_DIR="$HOME"

link() {
    local src="$DOTFILES/$1"
    local dest="$HOME_DIR/$1"

    mkdir -p "$(dirname "$dest")"

    if [ -e "$dest" ] && [ ! -L "$dest" ]; then
        echo "BACKUP: $dest -> ${dest}.bak"
        mv "$dest" "${dest}.bak"
    fi

    ln -sfn "$src" "$dest"
    echo "LINK: $dest -> $src"
}

# Shell
link .zshrc
link .zprofile

# Binaries — install system-wide so all users and sudo can access them
sudo cp "$DOTFILES/.local/bin/drawterm" /usr/local/bin/drawterm
sudo chmod +x /usr/local/bin/drawterm
echo "INSTALL: /usr/local/bin/drawterm"

# Oh My Zsh - install as real git repo, not symlink
if [ -L "$HOME_DIR/.oh-my-zsh" ]; then
    rm "$HOME_DIR/.oh-my-zsh"
fi
if [ ! -d "$HOME_DIR/.oh-my-zsh" ]; then
    echo "CLONE: oh-my-zsh"
    git clone https://github.com/ohmyzsh/ohmyzsh.git "$HOME_DIR/.oh-my-zsh"
fi

# zsh-autosuggestions plugin
if [ ! -d "$HOME_DIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    echo "CLONE: zsh-autosuggestions"
    git clone https://github.com/zsh-users/zsh-autosuggestions.git "$HOME_DIR/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
fi

# Custom zsh aliases
link .oh-my-zsh/custom/aliases.zsh

# Fonts
for f in "$DOTFILES"/.local/share/fonts/DejaVuSansM*; do
    link ".local/share/fonts/$(basename "$f")"
done

# Terminal & prompt
link .config/kitty
link .config/starship.toml

# Editor
link .config/nvim

# Desktop
link .config/cosmic

# Qt theming
link .config/qt5ct/qt5ct.conf
link .config/kdeglobals

# GTK2 theming
link .gtkrc-2.0
link .themes/Colloid-Red-Dark-Catppuccin

# Cursor theme
link .local/share/icons/Qogir-Recolored-Catppuccin-Macchiato-v2
link .icons/default

# Autostart overrides
link .config/autostart/org.kde.xwaylandvideobridge.desktop

# Apps
link .config/cava
link .config/fastfetch
link .homepage

# AI agents
link .agents

# AI Skills ecosystem
# Use `npx skills` to manage agent skills:
#   npx skills list          - List installed skills
#   npx skills add <package> - Install a skill
#   npx skills find [query]  - Search for skills
#   npx skills update        - Update all skills
# More at https://skills.sh/

# Create AI skills symlinks for .claude and .codex
mkdir -p "$HOME_DIR/.claude/skills"
mkdir -p "$HOME_DIR/.codex/skills"

# Symlink each skill individually to both .claude and .codex
if [ -d "$HOME_DIR/.agents/skills" ]; then
    for skill in "$HOME_DIR/.agents/skills"/*; do
        if [ -d "$skill" ]; then
            skill_name=$(basename "$skill")
            ln -sfn "$DOTFILES/.agents/skills/$skill_name" "$HOME_DIR/.claude/skills/$skill_name"
            ln -sfn "$DOTFILES/.agents/skills/$skill_name" "$HOME_DIR/.codex/skills/$skill_name"
            echo "LINK: .claude/skills/$skill_name -> $DOTFILES/.agents/skills/$skill_name"
            echo "LINK: .codex/skills/$skill_name -> $DOTFILES/.agents/skills/$skill_name"
        fi
    done
fi

# AI agent configuration files
ln -sfn "$DOTFILES/.agents/AGENTS.md" "$HOME_DIR/.codex/AGENTS.md"
ln -sfn "$DOTFILES/.agents/AGENTS.md" "$HOME_DIR/.claude/CLAUDE.md"
echo "LINK: .codex/AGENTS.md -> .dotfiles/.agents/AGENTS.md"
echo "LINK: .claude/CLAUDE.md -> .dotfiles/.agents/AGENTS.md"


# BrowserOS download
BROWSEROS_FILE="$HOME_DIR/.agents/browseros/BrowserOS_v0.30.0_x64.AppImage"
if [ ! -f "$BROWSEROS_FILE" ]; then
    echo "DOWNLOAD: $BROWSEROS_FILE"
    mkdir -p "$HOME_DIR/.agents/browseros"
    curl -L "https://github.com/browseros-ai/BrowserOS/releases/download/v0.30.0/BrowserOS_v0.30.0_x64.AppImage" -o "$BROWSEROS_FILE"
    chmod +x "$BROWSEROS_FILE"
fi

# Verbose boot
sudo grubby --update-kernel=ALL --remove-args="quiet splash rhgb"

# Papirus Catppuccin folders
PAPIRUS_DIR="/tmp/papirus-folders-catppuccin"
if [ ! -d "$PAPIRUS_DIR" ]; then
    git clone https://github.com/catppuccin/papirus-folders.git "$PAPIRUS_DIR"
fi
sudo cp -r "$PAPIRUS_DIR/src/"* /usr/share/icons/Papirus/
curl -sLo /tmp/papirus-folders https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders
chmod +x /tmp/papirus-folders
sudo /tmp/papirus-folders -C cat-mocha-mauve --theme Papirus-Dark

echo ""
echo "Done. Log out and back in for .zprofile/.zshrc changes to take effect."
echo ""
echo "Optional: Run these scripts to install MCP servers:"
echo "  ./setup_mcp_claude.sh  # Install MCP servers for Claude Code"
echo "  ./setup_mcp_codex.sh   # Install MCP servers for Codex"
