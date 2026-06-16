{ config, pkgs, ... }:

{
  programs = {
    firefox = {
      enable = true;
      profiles.default-release = {
        id = 0;
        path = "toq0r65u.default-release";
        settings = {
          "media.hardware-video-decoding.enabled" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          "media.ffvpx.enabled" = false;
        };
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nh = {
      enable = true;
      homeFlake = "${config.home.homeDirectory}/.config/home-manager";
    };

    helix = {
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
  };
}
