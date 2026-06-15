{
  inputs,
  lib,
  pkgs,
  config,
  ...
}:
{
  imports = [
    inputs.stylix.homeModules.stylix
  ];

  home.packages = with pkgs; [
    lxgw-wenkai
    sarasa-gothic
    maple-mono.NF-CN
    ioskeley-mono.normal-NF
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    noto-fonts-lgc-plus
    noto-fonts
    font-awesome
    lxgw-wenkai-screen
    inputs.iosevka.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.iosevka.packages.${pkgs.stdenv.hostPlatform.system}.normal
    inputs.iosevka.packages.${pkgs.stdenv.hostPlatform.system}.mono
  ];

  fonts.fontconfig = {
    enable = true;
    defaultFonts.monospace = lib.mkForce [
      "Iosevka Mono Custom"
      "LXGW WenKai Mono"
    ];
  };
  stylix = {
    enable = true;
    autoEnable = false;
    base16Scheme = "${pkgs.base16-schemes}/share/themes/gruvbox-material-dark-soft.yaml";
    fonts = {
      monospace = {
        name = "Iosevka Mono Custom";
      };
      serif = {
        name = "LXGW WenKai Screen";
      };
      sansSerif = {
        name = "LXGW WenKai Screen";
      };
      emoji = {
        name = "Noto Color Emoji";
      };
      sizes = {
        terminal = 16;
      };
    };

    targets.ghostty.enable = true;
    targets.fontconfig.enable = true;
    # targets.gtk.enable = true;
  };

  # Generate Stylix base16 colors for Neovim.
  # Written outside the nvim/ symlink to avoid conflicts with xdg.configFile.
  # Loaded in plugins.lua via dofile().
  xdg.configFile."stylix-nvim/base16.lua".text =
    let
      c = config.lib.stylix.colors.withHashtag;
    in
    ''
      return {
        base00 = "${c.base00}",
        base01 = "${c.base01}",
        base02 = "${c.base02}",
        base03 = "${c.base03}",
        base04 = "${c.base04}",
        base05 = "${c.base05}",
        base06 = "${c.base06}",
        base07 = "${c.base07}",
        base08 = "${c.base08}",
        base09 = "${c.base09}",
        base0A = "${c.base0A}",
        base0B = "${c.base0B}",
        base0C = "${c.base0C}",
        base0D = "${c.base0D}",
        base0E = "${c.base0E}",
        base0F = "${c.base0F}",
      }
    '';
}
