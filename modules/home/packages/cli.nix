{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.packages.cli;
in
{
  options.my.packages.cli.enable = lib.mkEnableOption "CLI utilities";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      jujutsu
      hellwal
      bat
      git
      wget
      curl
      jq
      ripgrep
      fastfetch
      fd
      fzf
      zoxide
      cliphist
      btop
      grim
      satty
      slurp
      starship
      gh
      yazi
      just
      nautilus
      exercism
    ];
  };
}
