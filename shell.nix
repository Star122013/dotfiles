let
  sources = import ./npins;
  pkgs = import sources.nixpkgs { };
in
pkgs.mkShell {
  name = "dotfile-devshell";
  buildInputs = with pkgs; [
    nixd
    nixfmt

    biome
    vscode-langservers-extracted
  ];
}
