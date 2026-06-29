# All development shells for this flake, in one file.
#
# A shell is a `perSystem.devShells.<name>` entry. `default` is what
# `nix develop` (no argument) enters.
{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      treefmt = {
        projectRootFile = "flake.nix";
        programs.deadnix.enable = true;
        programs.nixfmt.enable = true;
        programs.jsonfmt.enable = true;
        programs.stylua.enable = true;
      };

      pre-commit.settings.hooks = {
        treefmt.enable = true;
        deadnix.enable = true;
        statix.enable = true;
        end-of-file-fixer.enable = true;
        check-merge-conflicts.enable = true;
      };

      devShells = {
        # `nix develop` — Nix tooling for working on this flake.
        default = pkgs.mkShell {
          name = "nix";
          packages = with pkgs; [
            nixd
            nixfmt
            statix
            deadnix
            lua-language-server
            stylua
          ];
        };

        # `nix develop .#lint` — formatters and linters only, no LSP.
        lint = pkgs.mkShell {
          name = "lint";
          packages = with pkgs; [
            nixfmt
            statix
            deadnix
          ];
        };
      };
    };
}
