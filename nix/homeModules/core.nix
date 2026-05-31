{
  config,
  pkgs,
  ...
}:

let
  terminfoDirs = "${config.home.profileDirectory}/share/terminfo:/etc/terminfo:/usr/share/terminfo:/lib/terminfo";
in
{
  programs.home-manager.enable = true;

  home = {
    username = "cyrene";
    homeDirectory = "/var/home/cyrene";
    stateVersion = "26.05";
    enableNixpkgsReleaseCheck = false;

    sessionVariables = {
      TERMINFO_DIRS = terminfoDirs;
      XCURSOR_THEME = "Bibata-Modern-Ice";
      XCURSOR_SIZE = "24";
      XCURSOR_PATH = "${pkgs.bibata-cursors}/share/icons:${config.home.profileDirectory}/share/icons:${config.xdg.dataHome}/icons:/run/current-system/sw/share/icons";
    };

    # Put npm global packages in a user-writable directory.
    # This avoids npm trying to write to Nix's read-only /nix/store when pi
    # installs runtime helpers such as context-mode.
    file.".npmrc".text = ''
      prefix=${config.home.homeDirectory}/.local/share/npm
    '';

    sessionPath = [
      "$HOME/.local/share/npm/bin"
    ];
  };
}
