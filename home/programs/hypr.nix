{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.hypr;
  dotfilesDir = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
in
{
  options.my.programs.hypr.enable = lib.mkEnableOption "Hyprland dotfiles";

  config = lib.mkIf cfg.enable {
    xdg.configFile."hypr/hyprland.lua".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/hypr/hyprland.lua";
    xdg.configFile."hypr/modules".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/hypr/modules";
  };
}
