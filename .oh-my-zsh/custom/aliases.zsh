alias ssh='kitty +kitten ssh'

drawterm() {
    local ip="${1:-}"
    local pass="${2:-}"
    if [ -z "$ip" ]; then
        printf "host: "
        read ip
    fi
    if [ -z "$pass" ]; then
        printf "password: "
        read -rs pass
        printf "\n"
    fi
    command drawterm -h "$ip" -a "$ip" -u glenda -c 'rio -i /usr/glenda/bin/rc/riostart' &
    sleep 3
    wtype "$pass"
    sleep 0.5
    wtype -k Return
}

browseros() {
    local ext_dir="$HOME/.agents/browseros/extensions"
    local extensions="$ext_dir/isdcac,$ext_dir/ublock,$ext_dir/popup-blocker"
    ~/.agents/browseros/BrowserOS_v0.30.0_x64.AppImage \
        --load-extension="$extensions" \
        "$@"
}

kitty-help() {
    printf '\e[31m┌──────────────────── Kitty Shortcuts ────────────────────┐\e[0m\n'
    printf '\e[32m\U0000f2d0 Windows & Tabs\e[0m\n'
    printf '\e[32m│ ├\e[0m ctrl+shift+enter    New window (pane)\n'
    printf '\e[32m│ ├\e[0m ctrl+shift+n        New OS window\n'
    printf '\e[32m│ ├\e[0m ctrl+shift+w        Close window\n'
    printf '\e[32m│ ├\e[0m ctrl+shift+t        New tab\n'
    printf '\e[32m│ ├\e[0m ctrl+shift+q        Close tab\n'
    printf '\e[32m│ ├\e[0m ctrl+shift+right    Next tab\n'
    printf '\e[32m│ ├\e[0m ctrl+shift+left     Previous tab\n'
    printf '\e[32m│ ├\e[0m ctrl+shift+.        Move tab forward\n'
    printf '\e[32m│ ├\e[0m ctrl+shift+,        Move tab backward\n'
    printf '\e[32m└ └\e[0m ctrl+shift+alt+t    Set tab title\n'
    printf '\n'
    printf '\e[33m\U000f0640 Layouts\e[0m\n'
    printf '\e[33m│ ├\e[0m ctrl+shift+l        Cycle layouts (tall/fat/grid/stack)\n'
    printf '\e[33m└ └\e[0m ctrl+shift+z        Toggle zoom (fullscreen pane)\n'
    printf '\n'
    printf '\e[34m\U0000f14e Navigation\e[0m\n'
    printf '\e[34m│ ├\e[0m ctrl+shift+[        Previous window (pane)\n'
    printf '\e[34m│ ├\e[0m ctrl+shift+]        Next window (pane)\n'
    printf '\e[34m│ ├\e[0m ctrl+shift+f        Move window forward\n'
    printf '\e[34m│ ├\e[0m ctrl+shift+b        Move window backward\n'
    printf '\e[34m│ ├\e[0m ctrl+shift+r        Start resize mode\n'
    printf '\e[34m└ └\e[0m (then arrows)       Resize in resize mode\n'
    printf '\n'
    printf '\e[35m\U0000f15e Scrolling\e[0m\n'
    printf '\e[35m│ ├\e[0m ctrl+shift+h        Show scrollback in pager\n'
    printf '\e[35m│ ├\e[0m ctrl+shift+page_up  Scroll page up\n'
    printf '\e[35m│ ├\e[0m ctrl+shift+page_dn  Scroll page down\n'
    printf '\e[35m│ ├\e[0m ctrl+shift+home     Scroll to top\n'
    printf '\e[35m└ └\e[0m ctrl+shift+end      Scroll to bottom\n'
    printf '\n'
    printf '\e[36m\U0000f013 Other\e[0m\n'
    printf '\e[36m│ ├\e[0m ctrl+shift+equal    Increase font size\n'
    printf '\e[36m│ ├\e[0m ctrl+shift+minus    Decrease font size\n'
    printf '\e[36m│ ├\e[0m ctrl+shift+backsp   Reset font size\n'
    printf '\e[36m│ ├\e[0m ctrl+shift+f11      Toggle fullscreen\n'
    printf '\e[36m│ ├\e[0m ctrl+shift+u        Unicode input\n'
    printf '\e[36m│ ├\e[0m ctrl+shift+e        Edit config\n'
    printf '\e[36m└ └\e[0m ctrl+shift+f5       Reload config\n'
    printf '\e[31m└──────────────────────────────────────────────────────────┘\e[0m\n'
}

tmux-help() {
    printf '\e[31m┌──────────────────── Tmux Shortcuts ─────────────────────┐\e[0m\n'
    printf '\e[32m\U0000f2d0 Sessions & Windows\e[0m\n'
    printf '\e[32m│ ├\e[0m ctrl+b d            Detach session\n'
    printf '\e[32m│ ├\e[0m ctrl+b s            List sessions\n'
    printf '\e[32m│ ├\e[0m ctrl+b $            Rename session\n'
    printf '\e[32m│ ├\e[0m ctrl+b c            Create window\n'
    printf '\e[32m│ ├\e[0m ctrl+b &            Kill window\n'
    printf '\e[32m│ ├\e[0m ctrl+b ,            Rename window\n'
    printf '\e[32m│ ├\e[0m ctrl+b n            Next window\n'
    printf '\e[32m│ ├\e[0m ctrl+b p            Previous window\n'
    printf '\e[32m│ ├\e[0m ctrl+b 0-9          Switch to window 0-9\n'
    printf '\e[32m└ └\e[0m ctrl+b w            List windows\n'
    printf '\n'
    printf '\e[33m\U000f0640 Panes\e[0m\n'
    printf '\e[33m│ ├\e[0m ctrl+b %%            Split vertically\n'
    printf '\e[33m│ ├\e[0m ctrl+b "            Split horizontally\n'
    printf '\e[33m│ ├\e[0m ctrl+b x            Kill pane\n'
    printf '\e[33m│ ├\e[0m ctrl+b z            Toggle zoom\n'
    printf '\e[33m│ ├\e[0m ctrl+b space        Cycle layouts\n'
    printf '\e[33m│ ├\e[0m ctrl+b {            Move pane left\n'
    printf '\e[33m│ ├\e[0m ctrl+b }            Move pane right\n'
    printf '\e[33m└ └\e[0m ctrl+b !            Break pane to window\n'
    printf '\n'
    printf '\e[34m\U0000f14e Navigation\e[0m\n'
    printf '\e[34m│ ├\e[0m ctrl+b arrows       Switch pane\n'
    printf '\e[34m│ ├\e[0m ctrl+b o            Next pane\n'
    printf '\e[34m│ ├\e[0m ctrl+b ;            Last pane\n'
    printf '\e[34m│ ├\e[0m ctrl+b q            Show pane numbers\n'
    printf '\e[34m│ ├\e[0m ctrl+b ctrl+arrows  Resize pane\n'
    printf '\e[34m└ └\e[0m ctrl+b alt+arrows   Resize pane (5 cells)\n'
    printf '\n'
    printf '\e[35m\U0000f15e Copy Mode\e[0m\n'
    printf '\e[35m│ ├\e[0m ctrl+b [            Enter copy mode\n'
    printf '\e[35m│ ├\e[0m space               Start selection\n'
    printf '\e[35m│ ├\e[0m enter               Copy selection\n'
    printf '\e[35m│ ├\e[0m ctrl+b ]            Paste buffer\n'
    printf '\e[35m│ ├\e[0m q                   Exit copy mode\n'
    printf '\e[35m└ └\e[0m ctrl+b =            List all buffers\n'
    printf '\n'
    printf '\e[36m\U0000f013 Other\e[0m\n'
    printf '\e[36m│ ├\e[0m ctrl+b ?            List keybindings\n'
    printf '\e[36m│ ├\e[0m ctrl+b :            Command prompt\n'
    printf '\e[36m│ ├\e[0m ctrl+b t            Show clock\n'
    printf '\e[36m└ └\e[0m ctrl+b r            Reload config\n'
    printf '\e[31m└──────────────────────────────────────────────────────────┘\e[0m\n'
}
