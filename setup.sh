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
link .oh-my-zsh

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
link .config/environment.d/cosmic.conf
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
ln -sfn "$DOTFILES/agents/AGENTS.md" "$HOME_DIR/.codex/AGENTS.md"
ln -sfn "$DOTFILES/agents/AGENTS.md" "$HOME_DIR/.claude/CLAUDE.md"
echo "LINK: .codex/AGENTS.md -> .dotfiles/agents/AGENTS.md"
echo "LINK: .claude/CLAUDE.md -> .dotfiles/agents/AGENTS.md"

# zsh-autosuggestions into oh-my-zsh
ln -sfn "$DOTFILES/zsh-autosuggestions" "$DOTFILES/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
echo "LINK: oh-my-zsh/custom/plugins/zsh-autosuggestions -> zsh-autosuggestions"

# Verbose boot
sudo grubby --update-kernel=ALL --remove-args="quiet splash rhgb"

# Papirus Catppuccin folders
# sudo cp -r $DOTFILES/papirus-folders-catppuccin/src/* /usr/share/icons/Papirus/
# curl -LO https://raw.githubusercontent.com/PapirusDevelopmentTeam/papirus-folders/master/papirus-folders && chmod +x papirus-folders
# sudo ./papirus-folders -C cat-mocha-mauve --theme Papirus-Dark

echo ""
echo "Done. Log out and back in for environment.d changes to take effect."
echo ""
echo "Optional: Run these scripts to install MCP servers:"
echo "  ./setup_mcp_claude.sh  # Install MCP servers for Claude Code"
echo "  ./setup_mcp_codex.sh   # Install MCP servers for Codex"
