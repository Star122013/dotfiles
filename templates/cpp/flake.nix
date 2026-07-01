{
  description = "A flake for c-cpp devShells";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    git-hooks-nix = {
      url = "github:cachix/git-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
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
        { pkgs, config, ... }:
        {
          pre-commit.settings.hooks = {
            treefmt = {
              enable = true;
              settings = {
                formatters = with pkgs; [
                  clang-tools
                  cmake-format
                  nixfmt
                ];
                fail-on-change = false;
              };
            };
            end-of-file-fixer.enable = true;
            check-merge-conflicts.enable = true;
          };

          devShells.default = pkgs.mkShell {
            name = "c-cpp devShell";
            buildInputs = with pkgs; [
              vcpkg
              vcpkg-tool
              cmake
              cmake-language-server
              cmake-lint
            ];
            inputsFrom = [ config.pre-commit.devShell ];
          };
        };
    };
}
