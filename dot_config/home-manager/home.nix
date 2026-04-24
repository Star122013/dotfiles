{ pkgs, ... }:

{
  home.username = "cyrene";
  home.homeDirectory = "/var/home/cyrene";
  home.stateVersion = "25.11";

  imports = [
    ./plasma.nix
  ];

  home.packages = with pkgs; [
    nixgl.nixGLIntel
    git
    wget
    curl
    jq
    ripgrep
    fastfetch
    fd
    fzf
    nushell
    # editor & lsp
    helix

    nixd
    nixfmt

    kitty

    # fonts
    maple-mono.NF-CN
  ];

  programs.home-manager.enable = true;

  fonts.fontconfig.enable = true;
}
