{
  inputs,
  pkgs,
  ...
}:

{
  home.packages = with pkgs; [
    inputs.noctalia.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.hyprland-guiutils.packages.${pkgs.stdenv.hostPlatform.system}.default
    inputs.vicinae.packages.${pkgs.stdenv.hostPlatform.system}.default

    inputs.bluebuild.packages.${pkgs.stdenv.hostPlatform.system}.default
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
    fastfetch
    yazi

    # editor & lsp
    inputs.helix.packages.${pkgs.stdenv.hostPlatform.system}.helix

    nixd
    nil
    nixfmt
    lua-language-server

    inputs.ghostty.packages.${pkgs.stdenv.hostPlatform.system}.default
    kitty

    # fonts
    maple-mono.NF-CN
    ioskeley-mono.normal-NF
    nerd-fonts.symbols-only
    noto-fonts-color-emoji
    noto-fonts-lgc-plus
    noto-fonts
    font-awesome

    # theme
    papirus-icon-theme
    magnetic-catppuccin-gtk

    emacs-pgtk
    neovim

    firefox

    mpv
    go-musicfox
    yt-dlp
    freetube

    (
      let
        nixpkgs-qq-unfree = import inputs.nixpkgs-qq {
          system = pkgs.stdenv.hostPlatform.system;
          config.allowUnfree = true;
        };
      in
      nixpkgs-qq-unfree.qq.override {
        commandLineArgs = [
          "--enable-features=UseOzonePlatform"
          "--ozone-platform=wayland"
          "--ozone-platform-hint=auto"
          "--enable-wayland-ime"
          "--wayland-text-input-version=3"
        ];
      }
    )

    # ai
    pi-coding-agent

    # lang
    devenv
    nodejs-slim_26.npm
    nodejs-slim_26
    gcc
    tree-sitter
    zig
  ];
}
