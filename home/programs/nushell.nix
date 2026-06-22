{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.nushell;
  dotfilesDir = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
in
{
  options.my.programs.nushell.enable = lib.mkEnableOption "Nushell dotfiles";

  config = lib.mkIf cfg.enable {
    xdg.configFile."nushell/env.nu".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nushell/env.nu";
    xdg.configFile."nushell/config.nu".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/nushell/config.nu";
  };
}
