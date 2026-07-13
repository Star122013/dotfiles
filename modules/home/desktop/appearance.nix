{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.desktop.appearance;
in
{
  options.my.desktop.appearance.enable =
    lib.mkEnableOption "desktop appearance (cursor, GTK, fcitx5, dconf, mime)";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      papirus-icon-theme
      magnetic-catppuccin-gtk
    ];

    home.pointerCursor = {
      enable = true;
      package = pkgs.bibata-cursors;
      name = "Bibata-Modern-Ice";
      size = 24;
      gtk.enable = true;
      x11.enable = true;
    };

    gtk = {
      enable = true;
      gtk2.force = lib.mkForce true;
    };

    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          kdePackages.fcitx5-chinese-addons
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-zhwiki
          fcitx5-pinyin-minecraft
          fcitx5-mellow-themes
        ];
      };
    };

    dconf = {
      enable = true;
      settings = {
        "org/gnome/desktop/interface" = {
          color-scheme = "prefer-dark";
          enable-hot-corners = false;
        };
      };
    };

    xdg.mimeApps = {
      enable = true;
      defaultApplications = {
        "x-scheme-handler/http" = "firefox.desktop";
        "x-scheme-handler/https" = "firefox.desktop";
        "text/html" = "firefox.desktop";
      };
    };
  };
}
