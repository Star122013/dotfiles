{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.sway;
  dotfilesDir = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
in
{
  options.my.programs.sway.enable = lib.mkEnableOption "Sway window manager dotfiles";

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "sway/config".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/sway/config";
      "sway/config.d".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/sway/config.d";
      "sway/color_01.icc".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/sway/color_01.icc";
      # Generate colors from Stylix base16 scheme
      "sway/colors".text =
        let
          c = config.lib.stylix.colors.withHashtag;
        in
        ''
          # Sway colorscheme — auto-generated from Stylix base16 scheme
          # class                 border      background  text        indicator   child_border
          client.focused          ${c.base0D} ${c.base0D} ${c.base00} ${c.base0D} ${c.base0D}
          client.focused_inactive ${c.base04} ${c.base01} ${c.base05} ${c.base04} ${c.base01}
          client.unfocused        ${c.base01} ${c.base01} ${c.base05} ${c.base01} ${c.base01}
          client.urgent           ${c.base08} ${c.base08} ${c.base00} ${c.base08} ${c.base08}
          client.placeholder      ${c.base00} ${c.base00} ${c.base05} ${c.base00} ${c.base00}
          client.background       ${c.base00}
        '';
    };
  };
}
