{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.kitty;
in
{
  options.my.programs.kitty.enable = lib.mkEnableOption "Kitty terminal";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [ kitty ];
  };
}
