{
  description = "Rust devshell";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    rust-overlay.url = "github:oxalica/rust-overlay";
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
                  rustfmt
                  nixfmt
                ];
                fail-on-change = false;
              };
            };
            clippy.enable = true;
            end-of-file-fixer.enable = true;
            check-merge-conflicts.enable = true;
          };

          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            overlays = [
              inputs.rust-overlay.overlays.default
            ];
          };

          devShells = {
            default = pkgs.mkShell {
              nativeBuildInputs = with pkgs; [
                openssl
                pkg-config
                eza
                fd
                rust-bin.beta.latest.default
              ];
              inputsFrom = [ config.pre-commit.devShell ];
              shellHook = ''
                alias ls=eza
                alias find=fd
                echo "rust devshell loads successfully"
              '';
            };
          };
        };
    };
}
