{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  desktop = config.my.desktop;
  cfg = config.my.desktop.stylix;
  base16SchemePath = "${pkgs.base16-schemes}/share/themes/${desktop.base16Scheme}.yaml";
in
{
  imports = [ inputs.stylix.homeModules.stylix ];

  options.my.desktop.stylix.enable = lib.mkEnableOption "Stylix theming";

  config = lib.mkIf cfg.enable {
    # Stylix references font names that the fonts module installs, so pull it
    # in by default (overridable: set `my.desktop.fonts.enable = false;`).
    my.desktop.fonts.enable = lib.mkDefault true;

    stylix = {
      enable = true;
      autoEnable = false;
      base16Scheme = base16SchemePath;
      fonts = {
        monospace.name = desktop.fonts.monospace;
        serif.name = desktop.fonts.serif;
        sansSerif.name = desktop.fonts.serif;
        emoji.name = desktop.fonts.emoji;
        sizes.terminal = desktop.fonts.terminalSize;
      };

      targets.ghostty.enable = true;
      targets.fontconfig.enable = true;
      targets.gtk.enable = true;
      targets.helix.enable = true;
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


  };
}
