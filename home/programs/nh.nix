{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.nh;
in
{
  options.my.programs.nh.enable = lib.mkEnableOption "nh (Nix Helper)";

  config = lib.mkIf cfg.enable {
    programs.nh = {
      enable = true;
      homeFlake = "${config.home.homeDirectory}/.config/home-manager";
    };
  };
}
