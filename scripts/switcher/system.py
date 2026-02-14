import subprocess

def system_theme_switch(theme: str):
    target_theme = "prefer-light" if theme =="light" else "prefer-dark"    
    try:
        subprocess.run(["gsettings", "set", "org.gnome.desktop.interface", "color-scheme", target_theme], check=True )
        print(f"✅ Switched system theme to: {target_theme}")
    except Exception as e:
        print(f"Theme switch failed:{e}") 
