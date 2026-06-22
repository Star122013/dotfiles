{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.packages.games;
in
{
  options.my.packages.games.enable = lib.mkEnableOption "gaming";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      (pkgs.steam.override {
        extraLibraries = p: with p; [ mesa ];
      })
      steam-run
      gamescope
      mangohud
    ];
  };
}
