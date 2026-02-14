from .const_path import HOME, KITTY_CONFIG_DIR
import subprocess

# 获取 repo root: scripts/switcher/kitty.py -> scripts/switcher -> scripts -> repo_root
# REPO_ROOT = Path(__file__).parent.parent.parent.resolve()
THEME_DIR = KITTY_CONFIG_DIR / "themes"

LIGHT_THEME = "light.conf"
DARK_THEME = "dark.conf"


def kitty_switch_theme(theme: str):
    """
    Switch kitty theme by creating a relative symlink from current-theme.conf
    to a theme file in the themes directory.

    Args:
        theme: 'light' or 'dark'
    """

    target_link = HOME / ".config" / "kitty" / "current-theme.conf"

    if theme == "light":
        theme_filename = LIGHT_THEME
    else:
        theme_filename = DARK_THEME

    source_theme = THEME_DIR / theme_filename

    if not source_theme.exists():
        print(f"❌ Theme file not found: {source_theme}")
        return

    try:
        if target_link.is_symlink() or target_link.exists():
            target_link.unlink()

        target_link.symlink_to(source_theme.resolve())
        subprocess.run(["killall", "-SIGUSR1", "kitty"], check=True)
        print(f"✅ Switched kitty theme to: {theme_filename}")

    except Exception as e:
        print(f"❌ Failed to switch kitty theme: {e}")
