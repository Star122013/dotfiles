# Archived mini flake-parts experiment. Kept for reference; root flake uses real flake-parts.
{ inputs }:

module:
let
  lib = inputs.nixpkgs.lib;

  isDerivation = value: builtins.isAttrs value && value ? type && value.type == "derivation";
  isPlainAttrs = value: builtins.isAttrs value && !(isDerivation value);

  recursiveMerge =
    attrs:
    let
      mergeTwo =
        lhs: rhs:
        lhs
        // builtins.mapAttrs (
          name: rhsValue:
          if builtins.hasAttr name lhs && isPlainAttrs lhs.${name} && isPlainAttrs rhsValue then
            mergeTwo lhs.${name} rhsValue
          else
            rhsValue
        ) rhs;
    in
    builtins.foldl' mergeTwo { } attrs;

  last = list: builtins.elemAt list (builtins.length list - 1);

  callModule =
    module:
    if builtins.isPath module then
      callModule (import module)
    else if builtins.isFunction module then
      module moduleArgs
    else
      module;

  collectModules =
    module:
    let
      evaluated = callModule module;
      imports = evaluated.imports or [ ];
      current = builtins.removeAttrs evaluated [ "imports" ];
    in
    builtins.concatMap collectModules imports ++ [ current ];

  moduleArgs = {
    inherit
      inputs
      lib
      pkgsFor
      withSystem
      ;
  };

  modules = collectModules module;

  systemsDefinitions = builtins.filter (module: module ? systems) modules;
  systems =
    if systemsDefinitions == [ ] then
      throw "mkFlake: missing `systems`"
    else
      (last systemsDefinitions).systems;

  nixpkgsConfig = recursiveMerge (map (module: module.nixpkgs or { }) modules);

  pkgsFor =
    system:
    import inputs.nixpkgs {
      inherit system;
      config = nixpkgsConfig.config or { };
      overlays = nixpkgsConfig.overlays or [ ];
    };

  perSystemFunctions = builtins.filter builtins.isFunction (map (module: module.perSystem or null) modules);

  perSystemConfig = lib.genAttrs systems (
    system:
    recursiveMerge (
      map (
        perSystem:
        perSystem {
          inherit
            inputs
            lib
            pkgsFor
            system
            ;
          pkgs = pkgsFor system;
        }
      ) perSystemFunctions
    )
  );

  withSystem =
    system: callback:
    callback {
      inherit
        inputs
        lib
        pkgsFor
        system
        ;
      pkgs = pkgsFor system;
      config = perSystemConfig.${system};
    };

  flakeConfig = recursiveMerge (map (module: module.flake or { }) modules);

  perSystemOutputNames = [
    "apps"
    "checks"
    "devShells"
    "formatter"
    "legacyPackages"
    "packages"
  ];

  liftPerSystemOutput =
    outputName:
    lib.filterAttrs (_: value: value != null) (
      lib.genAttrs systems (
        system:
        let
          config = perSystemConfig.${system};
        in
        if builtins.hasAttr outputName config then config.${outputName} else null
      )
    );

  perSystemOutputs = builtins.listToAttrs (
    builtins.filter (output: output.value != { }) (
      map (outputName: {
        name = outputName;
        value = liftPerSystemOutput outputName;
      }) perSystemOutputNames
    )
  );
in
recursiveMerge [
  flakeConfig
  perSystemOutputs
]
