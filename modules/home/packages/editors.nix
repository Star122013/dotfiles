{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.packages.editors;
in
{
  options.my.packages.editors.enable = lib.mkEnableOption "editors and note-taking apps";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      zed-editor
      obsidian
      vscode
    ];
  };
}
