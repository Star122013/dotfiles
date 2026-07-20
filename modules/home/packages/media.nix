{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.packages.media;
in
{
  options.my.packages.media.enable = lib.mkEnableOption "media playback apps";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      piliplus
      ytmdesktop
    ];
  };
}
