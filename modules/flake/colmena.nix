{ inputs, ... }:

{
  flake.colmenaHive = inputs.colmena.lib.makeHive {
    meta = {
      nixpkgs = import inputs.nixpkgs {
        system = "x86_64-linux";
        config.allowUnfree = true;
      };
      specialArgs = {
        inherit inputs;
      };
    };

    router = {
      deployment = {
        targetHost = "10.10.10.1";
        targetUser = "root";
        buildOnTarget = true;
      };
      imports = [ ../../hosts/router ];
    };
  };
}
