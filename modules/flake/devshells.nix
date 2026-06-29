# All development shells for this flake, in one file.
#
# A shell is a `perSystem.devShells.<name>` entry. `default` is what
# `nix develop` (no argument) enters.
_:

{
  perSystem =
    { pkgs, config, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs = {
          deadnix.enable = true;
          nixfmt.enable = true;
          jsonfmt.enable = true;
          stylua.enable = true;
        };
      };

      pre-commit.settings = {
        hooks = {
          treefmt.enable = true;
          deadnix.enable = true;
          statix = {
            enable = true;
            settings.ignore = [ "hardware-configuration.nix" ];
          };
          end-of-file-fixer.enable = true;
          check-merge-conflicts.enable = true;
        };
      };

      devShells = {
        # `nix develop` — Nix tooling for working on this flake.
        default = pkgs.mkShell {
          name = "nix";
          packages = with pkgs; [
            nixd
            lua-language-server
            stylua
          ];
          inputsFrom = [ config.pre-commit.devShell ];
        };

        # `nix develop .#lint` — formatters and linters only, no LSP.
        lint = config.pre-commit.devShell;
      };
    };
}
