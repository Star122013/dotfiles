{ pkgs, ... }:

{
  home.username = "cyrene";
  home.homeDirectory = "/var/home/cyrene";
  home.stateVersion = "25.11";

  home.packages = with pkgs; [
    git
    wget
    curl
    jq
    ripgrep
    fd
    fzf
    nushell
    
    kitty

  ];

  programs.home-manager.enable = true;
}
