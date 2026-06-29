{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.niri;
  dotfilesDir = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
in
{
  options.my.programs.niri.enable = lib.mkEnableOption "Niri window manager dotfiles";

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "niri/config".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/niri/config";
      "niri/colors".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/niri/colors";
      "niri/config.kdl".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/niri/config.kdl";
    };
  };
}
