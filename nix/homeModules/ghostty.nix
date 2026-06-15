{ pkgs, ... }: {
  programs.ghostty = {
    enable = true;
    package = pkgs.ghostty_git;
    settings = {
      command = "nu";
      shell-integration-features = [
        "no-cursor"
        "ssh-terminfo"
      ];

      cursor-style = "block";
      cursor-style-blink = true;
      background-blur = true;
      window-decoration = "client";
      window-show-tab-bar = "auto";
      gtk-tabs-location = "bottom";
      gtk-wide-tabs = false;
      gtk-titlebar = false;
      gtk-titlebar-style = "native";

      # Behavior
      # quit-after-last-window-closed = true;
      # quit-after-last-window-closed-delay = "5m";
      confirm-close-surface = false;
      copy-on-select = "clipboard";
      keybind = [
        "ctrl+shift+w=close_surface"
        "ctrl+shift+h=goto_split:left"
        "ctrl+shift+j=goto_split:down"
        "ctrl+shift+k=goto_split:up"
        "ctrl+shift+l=goto_split:right"
        "ctrl+shift+backslash=new_split:right"
        "ctrl+shift+-=new_split:down"
      ];
    };
  };
}
