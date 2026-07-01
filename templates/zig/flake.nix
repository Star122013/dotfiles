{
  description = "flake for nix devShells";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zig = {
      url = "github:mitchellh/zig-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      flake-parts,
      zig,
      ...
    }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.git-hooks-nix.flakeModule
      ];

      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
        "x86_64-darwin"
      ];
      perSystem =
        {
          pkgs,
          system,
          config,
          ...
        }:
        {
          pre-commit.settings.hooks = {
            treefmt = {
              enable = true;
              settings = {
                formatters = with pkgs; [
                  zig.packages.${system}.default
                  nixfmt
                ];
                fail-on-change = false;
              };
            };
            end-of-file-fixer.enable = true;
            check-merge-conflicts.enable = true;
          };

          devShells.default = pkgs.mkShellNoCC {
            name = "zig devShell";
            buildInputs = with pkgs; [
              zls
              zig-zlint
            ];
            inputsFrom = [ config.pre-commit.devShell ];
          };
        };
    };
}
