# dotfiles — COSMIC on Fedora Asahi Remix

Catppuccin-themed COSMIC desktop on Apple Silicon.

## COSMIC install

```bash
sudo dnf copr enable ryanabx/cosmic-epoch
sudo dnf install cosmic-desktop
```

cosmic-greeter won't auto-enable if SDDM is already active. Repoint the symlink:
```bash
sudo ln -sfn /usr/lib/systemd/system/cosmic-greeter.service /etc/systemd/system/display-manager.service
```

## Catppuccin

[catppuccin/cosmic-desktop](https://github.com/catppuccin/cosmic-desktop)

```bash
git clone https://github.com/catppuccin/cosmic-desktop.git
```

- Settings -> Desktop -> Appearance -> Import -> `themes/cosmic-settings`
- Terminal -> View -> Color schemes -> Import -> `themes/cosmic-term`

## dotfiles setup

```bash
git clone --recursive <repo-url> ~/.dotfiles
cd ~/.dotfiles
./setup.sh
```

Re-login for `environment.d` to take effect.

## Qt theming

### Qt6 — CuteCosmic

[CuteCosmic](https://github.com/IgKh/cutecosmic) — auto-loads in cosmic-session. Reads COSMIC palette, draws widgets with Breeze. Rebuild after Qt6 updates.

```bash
sudo dnf install qt6-qtbase-devel qt6-qtbase-private-devel qt6-qtdeclarative-devel
git clone https://github.com/IgKh/cutecosmic.git && cd cutecosmic
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build
sudo cmake --install build
```

### Qt5 — qt5gtk2 via qt5ct

[qt5gtk2](https://github.com/trialuser02/qt5gtk2) inherits the GTK2 theme ([Colloid-Red-Dark-Catppuccin](https://github.com/vinceliuice/Colloid-gtk-theme)).

`QT_QPA_PLATFORMTHEME=qt5ct` is set in `.config/environment.d/qt-theme.conf`. Qt5 loads qt5ct which uses qt5gtk2 style. Qt6 doesn't have a qt5ct plugin so it ignores this and falls back to CuteCosmic.

```bash
sudo dnf install qt5ct qt5-qtbase-devel qt5-qtbase-private-devel qt5-qtbase-static gtk2-devel libX11-devel
git clone https://github.com/trialuser02/qt5gtk2.git && cd qt5gtk2
qmake-qt5 && make
sudo cp src/qt5gtk2-qtplugin/libqt5gtk2.so /usr/lib64/qt5/plugins/platformthemes/
sudo cp src/qt5gtk2-style/libqt5gtk2-style.so /usr/lib64/qt5/plugins/styles/
```

### GTK2

`.gtkrc-2.0` points to Colloid-Red-Dark-Catppuccin in `.themes/`. GTK3/4 handled by COSMIC.

## Tools installed

**Development:**
- neovim 0.11.5 (with LuaJIT)
- lazygit 0.47.2
- tree-sitter 0.25.10
- claude 2.1.42
- codex 0.101.0

**Search/Navigation:**
- fzf 0.67.0
- ripgrep 14.1.1
- fd 10.3.0

**Other:**
- git 2.52.0
- curl 8.11.1
- Nerd Fonts (DejaVuSansMNerdFont)
