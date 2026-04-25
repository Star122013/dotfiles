#!/usr/bin/env python3
# Kitty tab bar with Rosé Pine Dawn theme

import os
import socket

from kitty.boss import get_boss
from kitty.fast_data_types import Screen
from kitty.tab_bar import (
    DrawData, ExtraData, Formatter, TabBarData,
    TabAccessor, as_rgb, draw_attributed_string,
    draw_tab_with_separator,
)

# ---------- Rosé Pine Dawn 颜色常量 ----------
ROSE_PINE_DAWN_BG       = 0xfaf4ed  # 主背景色（米白）
ROSE_PINE_FG            = 0x575279  # 主文字色（深灰褐）
ROSE_PINE_SUBTLE        = 0x9893a5  # 非活动标签文字/副文本（浅紫灰）
ROSE_PINE_ACTIVE_TAB_BG = 0x907aa9  # 活动标签背景（鸢尾紫）
ROSE_PINE_ICON_SEP      = 0xcecacd  # 分隔符颜色（更浅的灰紫）
ROSE_PINE_NU_ICON       = 0xd7827e  # 左侧 nu 图标（暖玫瑰）
# 右侧单元格文字颜色（加深版）
COLOR_USER   = 0xd7827e  # 用户名 → 暖玫瑰
COLOR_HOST   = 0x56949f  # 主机名 → 深青绿
COLOR_CWD    = 0xea9d34  # 路径   → 金橙色
# -------------------------------------------

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
    active_id = get_boss().active_tab.id
    active_tab = TabAccessor(active_id)

    old_fg = screen.cursor.fg
    old_bg = screen.cursor.bg

    # ----- 左侧显示当前最老的进程名（通常是 nu）-----
    if index == 1:
        title = active_tab.active_oldest_exe  # 可能是 "nu"
        screen.cursor.italic = False
        screen.cursor.bold = False
        screen.cursor.fg = as_rgb(ROSE_PINE_NU_ICON)
        screen.cursor.bg = as_rgb(ROSE_PINE_DAWN_BG)
        screen.draw(f"  {title}")

    # ----- 活动标签左侧装饰 -----
    if tab.is_active:
        active_bg = draw_data.active_bg if draw_data.active_bg else ROSE_PINE_ACTIVE_TAB_BG
        inactive_bg = draw_data.inactive_bg if draw_data.inactive_bg else ROSE_PINE_DAWN_BG
        screen.cursor.fg = as_rgb(int(active_bg))
        screen.cursor.bg = as_rgb(int(inactive_bg))
        screen.draw(" ▐█")
    elif extra_data.prev_tab is None or extra_data.prev_tab.tab_id != active_id:
        screen.cursor.bg = as_rgb(ROSE_PINE_DAWN_BG)
        screen.cursor.fg = as_rgb(ROSE_PINE_SUBTLE)
        screen.draw(" │ ")

    screen.cursor.fg = old_fg
    screen.cursor.bg = old_bg

    # ----- 绘制标签标题（索引 + 名称）-----
    draw_tab_with_separator(
        draw_data,
        screen,
        tab,
        before,
        max_title_length,
        index,
        is_last,
        extra_data,
    )

    # ----- 活动标签右侧装饰 -----
    if tab.is_active:
        active_bg = draw_data.active_bg if draw_data.active_bg else ROSE_PINE_ACTIVE_TAB_BG
        inactive_bg = draw_data.inactive_bg if draw_data.inactive_bg else ROSE_PINE_DAWN_BG
        screen.cursor.fg = as_rgb(int(active_bg))
        screen.cursor.bg = as_rgb(int(inactive_bg))
        screen.draw("█▌ ")

    # ----- 右侧状态栏（用户/主机/路径）-----
    if is_last:
        draw_right_status(draw_data, screen, active_tab)

    return screen.cursor.x


def draw_right_status(draw_data: DrawData, screen: Screen, active_tab: TabAccessor) -> None:
    draw_attributed_string(Formatter.reset, screen)
    cells = create_cells(active_tab)

    # 计算空间，放不下时从左侧丢弃单元格
    while True:
        if not cells:
            return
        padding = (
            screen.columns
            - screen.cursor.x
            - sum(len(c[0]) + len(c[1]) + 5 for c in cells)
            - max(len(cells) - 1, 0)
        )
        if padding >= 0:
            break
        cells = cells[1:]

    if padding:
        screen.draw(" " * padding)

    # 背景色与标签栏背景一致
    screen.cursor.bg = as_rgb(ROSE_PINE_DAWN_BG)
    separator_fg = as_rgb(ROSE_PINE_ICON_SEP)

    for idx, cell in enumerate(cells):
        title, symbol, color = cell
        # 绘制分隔符（第一个前不加）
        if idx != 0:
            screen.cursor.fg = separator_fg
            screen.draw("│")
        # 绘制标题文字（使用指定颜色）
        screen.cursor.fg = as_rgb(color)
        screen.draw(f" {title}")
        # 绘制图标：与标题使用相同颜色（不再用浅灰色）
        screen.cursor.fg = as_rgb(color)
        screen.draw(f" ⟵ {symbol} ")
    # 恢复默认格式
    draw_attributed_string(Formatter.reset, screen)


def create_cells(active_tab: TabAccessor) -> list[tuple[str, str, int]]:
    """生成右侧状态单元格：[(文本, 图标, 颜色), ...]"""
    username = os.environ.get("USER") or os.environ.get("USERNAME") or "?"
    hostname = os.environ.get("HOSTNAME") or socket.gethostname() or "?"
    cwd = active_tab.active_oldest_wd or "?"

    # 缩短家目录和过长的路径
    if cwd and isinstance(cwd, str):
        home = os.path.expanduser("~")
        if cwd.startswith(home):
            cwd = "~" + cwd[len(home):]
        if len(cwd) > 30:
            last_component = os.path.basename(cwd.rstrip("/"))
            if len(last_component) > 30:
                cwd = last_component[:30] + "…"
            else:
                cwd = last_component

    return [
        (username, "", COLOR_USER),
        (hostname, "󰒋", COLOR_HOST),
        (cwd,      "", COLOR_CWD),
    ]
