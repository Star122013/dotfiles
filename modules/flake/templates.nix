{ lib, ... }:

let
  inherit (lib) hasPrefix;

  readDescription = dir:
    let
      content = builtins.readFile (dir + "/flake.nix");
      matches = builtins.match ".*description[[:space:]]*=[[:space:]]*\"([^\"]+)\".*" content;
    in
    if matches != null then builtins.head matches else "A ${builtins.baseNameOf dir} devShell";

  templatesDir = ../../templates;
  entries = builtins.readDir templatesDir;
in
builtins.attrNames entries
|> builtins.filter (name: entries.${name} == "directory" && !hasPrefix "_" name)
|> map (name: {
  inherit name;
  value = {
    path = templatesDir + "/${name}";
    description = readDescription (templatesDir + "/${name}");
  };
})
|> builtins.listToAttrs
|> (templates: {
  flake.templates = templates // {
    default = templates.nix or (builtins.elemAt (builtins.attrValues templates) 0);
  };
})
