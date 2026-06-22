{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.my.packages.extras;
  system = pkgs.stdenv.hostPlatform.system;
in
{
  options.my.packages.extras.enable = lib.mkEnableOption "extra input-derived packages";

  config = lib.mkIf cfg.enable {
    home.packages =
      with pkgs;
      [
        inputs.noctalia.packages.${system}.default
        inputs.hyprland-guiutils.packages.${system}.default
        inputs.vicinae.packages.${system}.default
        inputs.bluebuild.packages.${system}.default
        inputs.colmena.packages.${system}.colmena
      ]
      ++ [
        (
          let
            nixpkgs-qq-unfree = import inputs.nixpkgs-qq {
              inherit system;
              config.allowUnfree = true;
            };
          in
          nixpkgs-qq-unfree.qq.override {
            commandLineArgs = [
              "--enable-features=UseOzonePlatform"
              "--ozone-platform=wayland"
              "--ozone-platform-hint=auto"
              "--enable-wayland-ime"
              "--wayland-text-input-version=3"
            ];
          }
        )
      ];
  };
}
