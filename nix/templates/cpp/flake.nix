{
  description = "A flake for c-cpp devShells";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, treefmt-nix, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        treefmt-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        { pkgs, ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.deadnix.enable = true;
            programs.nixfmt.enable = true;
            programs.jsonfmt.enable = true;
            programs.clang-format.enable = true;
            programs.cmake-format.enable = true;
          };

          devShells.default = pkgs.mkShell {
            name = "c-cpp devShell";
            buildInputs = with pkgs; [
              clang-tools
              vcpkg
              vcpkg-tool
              cmake
              cmake-format
              cmake-language-server
              cmake-lint
            ];
          };
        };
    };
}
