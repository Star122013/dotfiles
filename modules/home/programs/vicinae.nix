{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.vicinae;
  dotfilesDir = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
in
{
  options.my.programs.vicinae.enable = lib.mkEnableOption "Vicinae dotfiles";

  config = lib.mkIf cfg.enable {
    xdg.configFile."vicinae/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/vicinae/settings.json";
  };
}
