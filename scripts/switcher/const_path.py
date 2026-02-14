from pathlib import Path

HOME = Path.home()
REPO_ROOT = Path(__file__).parent.parent.parent.resolve()

KITTY_CONFIG_DIR = REPO_ROOT / "config" / "kitty"

FISH_CONFIG= REPO_ROOT / "config" / "fish"
