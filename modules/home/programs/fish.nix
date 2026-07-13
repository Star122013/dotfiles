{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.fish;
in
{
  options.my.programs.fish.enable = lib.mkEnableOption "fish shell";

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;

      # Runs for every fish invocation (login + interactive + non-interactive).
      # Add ~/.local/bin to PATH idempotently.
      shellInit = ''
        # Ensure user-local bin is on PATH
        if not contains "$HOME/.local/bin" $PATH
          set -gx PATH "$HOME/.local/bin" $PATH
        end
        if not contains "$HOME/.local/share/npm/bin" $PATH
          set -gx PATH "$HOME/.local/share/npm/bin" $PATH
        end
      '';

      # Runs for interactive shells only. Only the variables that
      # the shell itself (or shell-launched CLI tools) actually need
      # are set here. WM/desktop-specific env (Qt/GTK/SDL/Fcitx5/XDG/
      # wayland/cursor/...) belongs in the DE session, not the shell.
      interactiveShellInit = ''
        # CLI tools (git, xdg-open, sudo, man, less, ...) consult these
        set -gx BROWSER firefox
        set -gx EDITOR hx

        # Help fish (and any terminfo-aware child) find terminfo databases
        set -gx TERMINFO_DIRS "$HOME/.nix-profile/share/terminfo:/etc/terminfo:/usr/share/terminfo:/lib/terminfo"
      '';
    };
  };
}
