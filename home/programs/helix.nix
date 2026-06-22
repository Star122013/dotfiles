{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.programs.helix;
  dotfilesDir = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
in
{
  options.my.programs.helix.enable = lib.mkEnableOption "Helix editor";

  config = lib.mkIf cfg.enable {
    programs.helix = {
      enable = true;
      package = pkgs.helix_git;
      settings = {
        editor = {
          color-modes = true;
          cursorline = true;
          line-number = "relative";
          bufferline = "multiple";
          end-of-line-diagnostics = "hint";
          indent-guides = {
            render = true;
            character = "▏";
            skip-levels = 1;
          };
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          lsp = {
            display-messages = true;
            display-inlay-hints = true;
          };
          statusline = {
            left = [
              "mode"
              "spinner"
              "version-control"
            ];
            center = [ "file-name" ];
            right = [
              "diagnostics"
              "selections"
              "position"
              "file-encoding"
              "file-line-ending"
              "file-type"
            ];
            separator = "│";
            mode.normal = "NORMAL";
            mode.insert = "INSERT";
            mode.select = "SELECT";
            diagnostics = [
              "warning"
              "error"
            ];
            workspace-diagnostics = [
              "warning"
              "error"
            ];
          };
          inline-diagnostics = {
            cursor-line = "warning";
          };
        };
        keys = {
          normal = {
            esc = [
              "collapse_selection"
              "keep_primary_selection"
            ];
            y = [
              "yank"
              ":clipboard-yank"
            ];
            p = ":clipboard-paste-before";
            P = ":clipboard-paste-after";
            space = {
              q = ":q";
              space = "file_picker";
              w = ":w";
            };
          };
          select = {
            y = [
              "yank"
              ":clipboard-yank"
            ];
            p = ":clipboard-paste-before";
            P = ":clipboard-paste-after";
          };
        };
      };
    };

    # Out-of-store symlink so edits in this repo are picked up live.
    xdg.configFile."helix/languages.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/helix/languages.toml";
  };
}
