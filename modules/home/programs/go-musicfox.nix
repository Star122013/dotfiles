{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.go-musicfox;
  dotfilesDir = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
in
{
  options.my.programs.go-musicfox.enable = lib.mkEnableOption "go-musicfox";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ go-musicfox ];

    xdg.configFile."go-musicfox/config.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/go-musicfox/config.toml";
  };
}
