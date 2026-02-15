from datetime import datetime
from kitty.boss import get_boss
from kitty.fast_data_types import Screen, add_timer, get_options
from kitty.tab_bar import (
    DrawData,
    ExtraData,
    Formatter,
    TabBarData,
    as_rgb,
    draw_attributed_string,
    draw_title,
)
from kitty.utils import color_as_int


opts = get_options()


CRUST  = as_rgb(color_as_int(opts.background))
MANTLE = as_rgb(0x181825)
TEXT   = as_rgb(color_as_int(opts.foreground))

RED    = as_rgb(color_as_int(opts.color1))
PEACH  = as_rgb(0xFAB387)
YELLOW = as_rgb(color_as_int(opts.color3))
GREEN  = as_rgb(color_as_int(opts.color2))
BLUE   = as_rgb(color_as_int(opts.color4))

TAB_COLORS = [RED, PEACH, BLUE, GREEN]

ICON             = "\uf302 "
LEFT_HALF_CIRCLE = "\ue0b6"
SEPARATOR_SYMBOL = "\ue0bc"

CHARGING_ICON   = "\U000f06a5 "
UNPLUGGED_ICONS = {
    10:  "\U000f0083 ",
    20:  "\U000f007b ",
    30:  "\U000f007c ",
    40:  "\U000f007d ",
    50:  "\U000f007e ",
    60:  "\U000f007f ",
    70:  "\U000f0080 ",
    80:  "\U000f0081 ",
    90:  "\U000f0082 ",
    100: "\U000f17e2 ",
}
CALENDAR_CLOCK_ICON = "\U000f00f0 "
TERMINAL_ICON       = "\ue795 "
BASH_ICON           = "\uf489 "

REFRESH_TIME        = 1


def _draw_icon(screen: Screen, index: int, first_tab_bg) -> int:
    if index != 1:
        return 0
    icon_bg = BLUE

    screen.cursor.bg = icon_bg
    screen.draw(" ")

    screen.cursor.fg = CRUST
    screen.cursor.bg = icon_bg
    screen.draw(ICON)

    screen.cursor.fg = icon_bg
    screen.cursor.bg = first_tab_bg
    screen.draw(SEPARATOR_SYMBOL)

    screen.cursor.x = 4
    return screen.cursor.x


def _draw_left_status(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    max_title_length: int,
    index: int,
    extra_data: ExtraData,
) -> int:
    if screen.cursor.x >= screen.columns - right_status_length:
        return screen.cursor.x

    tab_color = TAB_COLORS[(index - 1) % len(TAB_COLORS)]

    tab_bg = tab_color if tab.is_active else as_rgb(int(draw_data.inactive_bg))
    tab_fg = CRUST if tab.is_active else TEXT

    if extra_data.next_tab:
        next_tab = extra_data.next_tab
        next_tab_bg = TAB_COLORS[index % len(TAB_COLORS)] if next_tab.is_active else as_rgb(int(draw_data.inactive_bg))
    else:
        next_tab_bg = CRUST

    if screen.cursor.x <= 4:  # space (1 char) + icon (2 chars) + separator (1 char)
        screen.cursor.x = 4

    screen.cursor.bg = tab_bg
    screen.cursor.fg = tab_fg

    screen.draw(" ")
    draw_title(draw_data, screen, tab, index, max_title_length)

    screen.cursor.fg = tab_bg
    screen.cursor.bg = next_tab_bg
    screen.draw(SEPARATOR_SYMBOL)

    return screen.cursor.x


def _get_active_process_name_cell() -> dict:
    cell = {"icon": TERMINAL_ICON, "icon_bg": GREEN, "text": ""}
    boss = get_boss()

    if not boss:
        return cell

    active_window = boss.active_window
    if not active_window or not active_window.child:
        return cell

    foreground_processes = active_window.child.foreground_processes
    if not foreground_processes or not foreground_processes[0]["cmdline"]:
        return cell

    long_process_name = foreground_processes[0]["cmdline"][0]
    name = long_process_name.rsplit("/", 1)[-1]
    cell["text"] = name
    if name == "bash":
        cell["icon"] = BASH_ICON

    return cell


def _get_datetime_cell() -> dict:
    now = datetime.now().strftime("%H:%M %d-%m-%Y")
    return {"icon": CALENDAR_CLOCK_ICON, "icon_bg": BLUE, "text": now}


def _get_battery_cell() -> dict:
    cell = {"icon": "", "icon_bg": YELLOW, "text": ""}

    try:
        with open("/sys/class/power_supply/macsmc-battery/status", "r") as f:
            status = f.read().strip()
        with open("/sys/class/power_supply/macsmc-battery/capacity", "r") as f:
            percent = int(f.read().strip())

        if status == "Charging":
            cell["icon"] = CHARGING_ICON
        else:
            cell["icon"] = UNPLUGGED_ICONS[
                min(UNPLUGGED_ICONS.keys(), key=lambda x: abs(percent - x))
            ]
        cell["text"] = f"{percent}%"
    except FileNotFoundError:
        pass

    return cell


def _create_cells() -> list[dict]:
    cells = []

    battery_cell = _get_battery_cell()
    if battery_cell["text"]:
        cells.append(battery_cell)

    process_cell = _get_active_process_name_cell()
    if process_cell["text"]:
        cells.append(process_cell)

    cells.append(_get_datetime_cell())
    return cells


def _draw_right_status(screen: Screen, is_last: bool, cells: list[dict], draw_data: DrawData) -> int:
    if not is_last:
        return 0

    draw_attributed_string(Formatter.reset, screen)

    screen.cursor.x = screen.columns - right_status_length

    tab_fg = as_rgb(int(draw_data.inactive_fg))

    screen.cursor.bg = CRUST
    for c in cells:
        screen.cursor.fg = c["icon_bg"]
        screen.draw(LEFT_HALF_CIRCLE)

        screen.cursor.bg = c["icon_bg"]
        screen.cursor.fg = CRUST
        screen.draw(c["icon"])

        screen.cursor.bg = MANTLE
        screen.cursor.fg = tab_fg
        screen.draw(f" {c['text']} ")

    return screen.cursor.x


def _redraw_tab_bar(_):
    tm = get_boss().active_tab_manager
    if tm is not None:
        tm.mark_tab_bar_dirty()


timer_id = None
right_status_length = -1


def draw_tab(
    draw_data: DrawData,
    screen: Screen,
    tab: TabBarData,
    before: int,
    max_title_length: int,
    index: int,
    is_last: bool,
    extra_data: ExtraData,
) -> int:
    global timer_id, right_status_length

    if timer_id is None:
        timer_id = add_timer(_redraw_tab_bar, REFRESH_TIME, True)

    cells = _create_cells()
    right_status_length = 0
    for cell in cells:
        right_status_length += 3 + len(cell["icon"]) + len(cell["text"])

    if index == 1:
        first_tab_bg = TAB_COLORS[0] if tab.is_active else as_rgb(int(draw_data.inactive_bg))
    else:
        first_tab_bg = as_rgb(int(draw_data.default_bg))

    _draw_icon(screen, index, first_tab_bg)

    end = _draw_left_status(
        draw_data,
        screen,
        tab,
        max_title_length,
        index,
        extra_data,
    )

    _draw_right_status(screen, is_last, cells, draw_data)

    return end
