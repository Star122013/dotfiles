{ inputs, lib, ... }:

let
  importDir = import ../../libs/importDir.nix { inherit lib; };
in
{
  # Auto-import every flake-parts module under ./flake. The devShells live
  # in a single file (../devshells/default.nix) and are imported explicitly.
  imports = (importDir ./.);

  systems = [
    "x86_64-linux"
    "aarch64-linux"
    "aarch64-darwin"
    "x86_64-darwin"
  ];

  # A single configured nixpkgs, shared by every perSystem module
  # (devShells, packages, etc.) so allowUnfree is consistent.
  perSystem =
    { system, ... }:
    {
      _module.args.pkgs = import inputs.nixpkgs {
        inherit system;
        config.allowUnfree = true;
      };
    };
}
