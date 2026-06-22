{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.yt-dlp;
  dotfilesDir = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
in
{
  options.my.programs.yt-dlp.enable = lib.mkEnableOption "yt-dlp dotfiles";

  config = lib.mkIf cfg.enable {
    xdg.configFile."yt-dlp".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/yt-dlp";
  };
}
