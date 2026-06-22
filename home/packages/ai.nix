{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.packages.ai;
in
{
  options.my.packages.ai.enable = lib.mkEnableOption "AI tooling";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      pi-coding-agent
      llama-cpp
    ];
  };
}
