from .const_path import HOME, FISH_CONFIG

THEME_DIR = FISH_CONFIG / "themes"

LIGHT_THEME = "dayfox.fish"
DARK_THEME = "duskfox.fish"

def fish_theme_switch(theme: str):
    target_link = HOME / ".config" / "fish" / "conf.d" / "current_theme.fish"
    
    source_theme = THEME_DIR / DARK_THEME if theme == "dark" else THEME_DIR / LIGHT_THEME
    
    if not source_theme.resolve().exists():
        print(f"File not found: {source_theme}")
    try:
        if target_link.exists() or target_link.is_symlink():
            target_link.unlink()

        target_link.symlink_to(source_theme.resolve())
        print(f"✅ Switched fish theme to: {source_theme}")

    except Exception as e:
        print(f"Failed to switch fish theme: {e}")
