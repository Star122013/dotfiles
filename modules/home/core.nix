{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.core;
  terminfoDirs = "${config.home.profileDirectory}/share/terminfo:/etc/terminfo:/usr/share/terminfo:/lib/terminfo";
in
{
  options.my.core = {
    enable = lib.mkEnableOption "core home environment (user info, session variables, nix settings)";

    username = lib.mkOption {
      type = lib.types.str;
      default = "cyrene";
      description = "The user name for this home configuration.";
    };

    homeDirectory = lib.mkOption {
      type = lib.types.str;
      default = "/var/home/${cfg.username}";
      defaultText = lib.literalExpression ''"/var/home/''${cfg.username}"'';
      description = "The user's home directory.";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.home-manager.enable = true;

    nix.package = pkgs.nix;
    nix.settings = {
      experimental-features = [
        "nix-command"
        "flakes"
        "pipe-operators"
      ];
      extra-substituters = [
        "https://nix-community.cachix.org"
        "https://star122013.cachix.org"
        "https://colmena.cachix.org"
        "https://noctalia.cachix.org"
        "https://mirror.sjtu.edu.cn/nix-channels/store?priority=20"
      ];
      extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        "star122013.cachix.org-1:VJPo5Pk/QRlq0tBwurSIxKq6+YUJ8s/3sM19BSt93lg="
        "colmena.cachix.org-1:7BzpDnjjH8ki2CT3f6GdOk7QAzPOl+1t3LvTLXqYcSg="
        "noctalia.cachix.org-1:pCOR47nnMEo5thcxNDtzWpOxNFQsBRglJzxWPp3dkU4="
      ];
    };

    home = {
      inherit (cfg) username homeDirectory;
      stateVersion = "26.05";
      enableNixpkgsReleaseCheck = false;

      sessionVariables = {
        TERMINFO_DIRS = terminfoDirs;
        XCURSOR_THEME = "Bibata-Modern-Ice";
        XCURSOR_SIZE = "24";
        XCURSOR_PATH = "${pkgs.bibata-cursors}/share/icons:${config.home.profileDirectory}/share/icons:${config.xdg.dataHome}/icons:/run/current-system/sw/share/icons";
        GDK_BACKEND = "wayland,x11,*";
        BROWSER = "firefox";
        WLR_RENDERER = "vulkan";

        # Wayland
        XDG_SESSION_TYPE = "wayland";
        XDG_CURRENT_DESKTOP = "Sway";
        XDG_SESSION_DESKTOP = "Sway";

        # Sway 1.12: suppress unsupported GPU warning (NVIDIA proprietary etc.)
        SWAY_UNSUPPORTED_GPU = "1";

        # Qt
        QT_QPA_PLATFORM = "wayland";
        QT_QPA_PLATFORMTHEME = "gtk3";
        QT_IM_MODULES = "wayland;fcitx";

        # GTK
        # GTK_IM_MODULE = "fcitx";

        # SDL
        SDL_VIDEODRIVER = "wayland,x11";
        SDL_IM_MODULE = "fcitx";

        # Mozilla
        MOZ_ENABLE_WAYLAND = "1";

        # Fcitx5
        XMODIFIERS = "@im=fcitx";
        INPUT_METHOD = "fcitx";

        # Other
        EDITOR = "hx";
        CLUTTER_BACKEND = "wayland";
        DISPLAY = ":0";
      };

      # Put npm global packages in a user-writable directory.
      # This avoids npm trying to write to Nix's read-only /nix/store when pi
      # installs runtime helpers such as context-mode.
      file.".npmrc".text = ''
        prefix=${config.home.homeDirectory}/.local/share/npm
      '';

      sessionPath = [ "$HOME/.local/share/npm/bin" ];
    };
  };
}
