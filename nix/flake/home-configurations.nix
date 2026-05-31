{
  config,
  inputs,
  ...
}:

let
  modules = [
    config.flake.homeModules.cyrene
    { nix.nixPath = [ "nixpkgs=${inputs.nixpkgs}" ]; }
  ];
in
{
  imports = [
    inputs.home-manager.flakeModules.home-manager
  ];

  flake.homeModules.cyrene = ../homeModules;

  flake.homeConfigurations = {
    "cyrene" = inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      inherit modules;
      extraSpecialArgs = { inherit inputs; };
    };
  };
}
