{
  config,
  inputs,
  ...
}:

let
  # The user this home configuration targets. Change this single value to
  # deploy for a different user — it drives both the configuration name
  # (`.#${username}`) and the `my.core.username` / `homeDirectory` options.
  username = "qwerhyy";

  main-modules = [
    config.flake.homeModules.default
    { nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; }
    inputs.chaotic.homeManagerModules.default
    {
      # The reusable module only *declares* the options; this is where they
      # are turned on for this user.
      my = {
        core = {
          enable = true;
          inherit username;
        };

        packages = {
          cli.enable = true;
          editors.enable = true;
          media.enable = true;
          ai.enable = true;
          games.enable = true;
          lang.enable = true;
          extras.enable = true;
        };

        programs = {
          # editors / terminals with HM-native config
          firefox.enable = true;
          helix.enable = true;
          ghostty.enable = true;
          kitty.enable = true;
          mpv.enable = true; # auto-enables yt-dlp (NAND: set yt-dlp.enable=false to skip)
          direnv.enable = true;
          bash.enable = true;
          fish.enable = true;
          starship.enable = true;
          nh.enable = true;
          # dotfile-only modules (out-of-store symlinks)
          niri.enable = true;
          hypr.enable = true;
          sway.enable = true;
          nvim.enable = true;
          nushell.enable = true;
          emacs.enable = true;
          vicinae.enable = true;
          go-musicfox.enable = true;
        };

        # Enabling `desktop` auto-enables appearance / fonts / stylix (each
        # set with mkDefault, so any of them can be turned off individually —
        # e.g. `desktop.fonts.enable = false;` — a NAND override).
        desktop = {
          enable = true;
          base16Scheme = "rose-pine-moon";
          # base16Scheme = builtins.fetchurl {
          #   url = "https://raw.githubusercontent.com/Sequoia-Theme/base16/main/sequoia-moonlight-dark.yaml";
          #   sha256 = "sha256-vHp1J/yRTGp1sr3TOD0TEPMKett6/Tr9Az6boUvABZI=";
          # };
          fonts = {
            monospace = "PragmataPro";
            monospaceFallback = "LXGW WenKai Mono";
            serif = "LXGW WenKai Screen";
            sansSerif = "LXGW WenKai Screen";
          };
        };
      };
    }
  ];
in
{
  imports = [ inputs.home-manager.flakeModules.home-manager ];

  flake.homeModules.default = ../../modules/home;

  flake.homeConfigurations.${username} = inputs.home-manager.lib.homeManagerConfiguration {
    pkgs = import inputs.nixpkgs {
      system = "x86_64-linux";
      config.allowUnfree = true;
    };
    modules = main-modules;
    extraSpecialArgs = {
      inherit inputs;
    };
  };
}
