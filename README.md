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

Re-login for `.zprofile` to take effect.

### Optional follow-up scripts

- `./setup_mcp_claude.sh` — register MCP servers (browseros, chrome-devtools, context7, filesystem, mcp-compass, memory, playwright, sequential-thinking) with Claude Code.
- `./setup_mcp_codex.sh` — same MCP servers for Codex.
- `./setup-keyring.py` — create the default gnome-keyring (prompts for a password the first time). Needed before any libsecret-using app can save credentials.
- `./setup_java.sh` — install `asahi-java` JVM helper (and `/etc/profile.d/jvm.sh` for `JAVA_HOME`). Run `./setup_java.sh uninstall` to revert.

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

`QT_QPA_PLATFORMTHEME=qt5ct` lives in `.zprofile`. `/usr/bin/start-cosmic` defaults the var to `cosmic` if it sees it empty, but does its `[ -z ]` check *after* `exec -l "$SHELL"` — so a login-shell file like `.zprofile` runs first and wins. `environment.d` doesn't work here: it's loaded by the systemd user manager only after cosmic-comp has already inherited start-cosmic's value, so children launched by cosmic-comp never see it.

Qt5 apps then load qt5ct → qt5gtk2 → GTK2 theme. Qt6 ignores qt5ct (no Qt6 plugin) and CuteCosmic loads independently.

Rebuild qt5gtk2 after Qt5 minor updates — the `.so`s are ABI-tied to the running Qt5.

```bash
sudo dnf install qt5ct qt5-qtbase-devel qt5-qtbase-private-devel qt5-qtbase-static gtk2-devel libX11-devel
git clone https://github.com/trialuser02/qt5gtk2.git && cd qt5gtk2
qmake-qt5 && make
sudo cp src/qt5gtk2-qtplugin/libqt5gtk2.so /usr/lib64/qt5/plugins/platformthemes/
sudo cp src/qt5gtk2-style/libqt5gtk2-style.so /usr/lib64/qt5/plugins/styles/
```

### GTK2

`.gtkrc-2.0` points to Colloid-Red-Dark-Catppuccin in `.themes/`. GTK3/4 handled by COSMIC.

## Known issues

### WiFi flap on 2.4 GHz with Bluetooth (BCM4387)

BT/WiFi coexistence bug on the combo radio. Anything that wakes BT (kdeconnectd discovery, bluetoothd polling, A2DP) starves 2.4 GHz WiFi airtime. The kernel locally requests a disconnect; reauth then fails with status 16 ("auth timeout") on fabricated BSSID `00:00:00:00:00:00`. About 25% uptime in practice. `rfkill block bluetooth` makes WiFi rock solid (zero events for minutes).

5 GHz is unaffected — radios don't share airtime. **The fix is connecting to a 5 GHz BSS.** Disabling kdeconnectd reduces frequency but doesn't eliminate the issue.

Tracked upstream at [AsahiLinux/linux#486](https://github.com/AsahiLinux/linux/issues/486). Kernel 6.19.13-400 added BT-side coex commands but only for the BT-audio path; the WiFi side is still unprotected. brcmfmac's existing `crit_proto_start` hook only covers DHCP, leaving auth/assoc exposed.

After resume from sleep, WiFi often goes completely dead and needs a full reboot.

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
