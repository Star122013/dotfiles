{
  description = "flake for nix devShells";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, treefmt-nix, zig, ... }:
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
        { pkgs, system', ... }:
        {
          treefmt = {
            projectRootFile = "flake.nix";
            programs.deadnix.enable = true;
            programs.nixfmt.enable = true;
            programs.jsonfmt.enable = true;
            programs.zig.enable = true;
          };

          devShells.default = pkgs.mkShellNoCC {
            name = "nix devShell";
            buildInputs = with pkgs; [
              zig.packages.master
              zls
              zig-zlint
            ];
          };
        };
    };
}
