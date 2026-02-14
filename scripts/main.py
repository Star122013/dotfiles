from datetime import datetime
from .switcher import switchers


def main():
    hour = datetime.now().hour
    if 6 < hour < 18:
        theme = "light"
    else:
        theme = "dark"

    for switcher in switchers:
        switcher(theme)


if __name__ == "__main__":
    main()
