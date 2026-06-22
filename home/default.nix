# Reusable Home Manager module that pulls in every module under this
# directory. Each module declares its own `my.*.enable` option and
# gates its configuration behind `mkIf`; the consumer (see
# nix/flake/home-configurations.nix) decides what to turn on.
{ lib, ... }:
let
  importDir = import ../lib/importDir.nix { inherit lib; };
in
{
  imports = importDir ./.;
}
