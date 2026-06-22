# Collect every *.nix module under this directory and add them to imports.
# Each module provides reusable NixOS configuration snippets.
{ lib, ... }:
let
  importDir = import ../lib/importDir.nix { inherit lib; };
in
{
  imports = importDir ./.;
}
