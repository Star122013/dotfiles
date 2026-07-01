{
  config,
  lib,
  pkgs,
  ...
}:

let
  cfg = config.my.packages.lang;
in
{
  options.my.packages.lang.enable = lib.mkEnableOption "language toolchains and LSPs";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      # language runtimes / toolchains
      devenv
      nodejs-slim_26.npm
      nodejs-slim_26
      gcc
      tree-sitter
      zig
      uv
      cargo

      # Nix / editor LSPs
      nixd
      nil
      nixfmt
      lua-language-server
      emmylua-ls
      typescript-language-server
      vscode-langservers-extracted
    ];
  };
}
