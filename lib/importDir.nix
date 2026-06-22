# Recursively collect every *.nix file under `dir` (skipping any
# default.nix, which is reserved for aggregation), returning a list
# of paths suitable for use in `imports`.
#
# Example:
#   imports = import ./importDir.nix ./.;
{ lib }:
let
  inherit (lib) hasSuffix;
  collect =
    d:
    let
      entries = builtins.readDir d;
      isNix = name: hasSuffix ".nix" name;
    in
    builtins.attrNames entries
    |> builtins.concatMap (
      name:
      let
        path = d + "/${name}";
      in
      if entries.${name} == "directory" then
        collect path
      else if name == "default.nix" then
        [ ]
      else if isNix name then
        [ path ]
      else
        [ ]
    );
in
collect
