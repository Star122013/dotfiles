# All development shells for this flake, in one file.
#
# A shell is a `perSystem.devShells.<name>` entry. `default` is what
# `nix develop` (no argument) enters.
{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells = {
        # `nix develop` — Nix tooling for working on this flake.
        default = pkgs.mkShell {
          name = "nix";
          packages = with pkgs; [
            nixd
            nixfmt
            statix
            deadnix

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
