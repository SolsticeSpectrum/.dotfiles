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
TEMP_ICONS = {
    60:  ("\uf2ca ", BLUE),   # cool
    80:  ("\uf2c9 ", YELLOW), # warm
    100: ("\uef2a ", RED),    # hot
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
    boss = get_boss()

    if not boss:
        return {"icon": TERMINAL_ICON, "icon_bg": GREEN, "text": ""}

    active_window = boss.active_window
    if not active_window or not active_window.child:
        return {"icon": TERMINAL_ICON, "icon_bg": GREEN, "text": ""}

    foreground_processes = active_window.child.foreground_processes
    if not foreground_processes or not foreground_processes[0]["cmdline"]:
        return {"icon": TERMINAL_ICON, "icon_bg": GREEN, "text": ""}

    long_process_name = foreground_processes[0]["cmdline"][0]
    proc_name = long_process_name.rsplit("/", 1)[-1]
    icon = BASH_ICON if proc_name == "bash" else TERMINAL_ICON

    return {"icon": icon, "icon_bg": GREEN, "text": proc_name}


def _get_datetime_cell() -> dict:
    now = datetime.now().strftime("%H:%M %d-%m-%Y")
    return {"icon": CALENDAR_CLOCK_ICON, "icon_bg": BLUE, "text": now}


def _get_battery_cell() -> dict:
    try:
        with open("/sys/class/power_supply/macsmc-battery/status", "r") as f:
            status = f.read().strip()
        with open("/sys/class/power_supply/macsmc-battery/capacity", "r") as f:
            bat_val = int(f.read().strip())

        if status == "Charging":
            icon = CHARGING_ICON
        else:
            icon = UNPLUGGED_ICONS[
                min(UNPLUGGED_ICONS.keys(), key=lambda x: abs(bat_val - x))
            ]

        if bat_val >= 50:
            bg = GREEN
        elif bat_val >= 20:
            bg = YELLOW
        else:
            bg = RED

        bat_text = f"{bat_val}%"
        return {"icon": icon, "icon_bg": bg, "text": bat_text}
    except FileNotFoundError:
        return {"icon": "", "icon_bg": RED, "text": ""}


def _get_cpu_cell() -> dict:
    import subprocess
    try:
        cpu = subprocess.check_output(["ps", "-A", "-o", "%cpu"], text=True).splitlines()
        cpu_val = sum(float(x) for x in cpu[1:] if x.strip())
        cpu_text = f"{cpu_val:.0f}%"

        if cpu_val >= 80:
            bg = RED
        elif cpu_val >= 50:
            bg = YELLOW
        else:
            bg = GREEN
    except:
        cpu_text = "?%"
        bg = RED

    return {"icon": "\U000f0487 ", "icon_bg": bg, "text": cpu_text}


def _get_temp_cell() -> dict:
    try:
        with open("/sys/class/thermal/thermal_zone0/temp", "r") as f:
            temp = int(f.read().strip())
        temp_val = temp / 1000
        temp_text = f"{temp_val:.0f}°C"

        icon, bg = TEMP_ICONS[
            min(TEMP_ICONS.keys(), key=lambda x: abs(temp_val - x) if temp_val <= x else float('inf'))
        ]
    except:
        temp_text = "?°C"
        icon, bg = ("\uf2c9 ", RED)

    return {"icon": icon, "icon_bg": bg, "text": temp_text}


def _get_ram_cell() -> dict:
    try:
        with open("/proc/meminfo", "r") as f:
            lines = f.readlines()

        mem_total = 0
        mem_available = 0
        for line in lines:
            if line.startswith("MemTotal:"):
                mem_total = int(line.split()[1])
            elif line.startswith("MemAvailable:"):
                mem_available = int(line.split()[1])

        if mem_total > 0:
            mem_used = mem_total - mem_available
            ram_val = (mem_used / mem_total) * 100
            ram_text = f"{ram_val:.0f}%"

            if ram_val >= 80:
                bg = RED
            elif ram_val >= 50:
                bg = YELLOW
            else:
                bg = GREEN
        else:
            ram_text = "?%"
            bg = RED
    except:
        ram_text = "?%"
        bg = RED

    return {"icon": "\uf2db ", "icon_bg": bg, "text": ram_text}


def _create_cells() -> list[dict]:
    cells = []

    battery_cell = _get_battery_cell()
    if battery_cell["text"]:
        cells.append(battery_cell)

    cells.append(_get_cpu_cell())
    cells.append(_get_ram_cell())
    cells.append(_get_temp_cell())

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
