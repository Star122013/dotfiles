# Router machine profile.
# Aggregates per-feature modules; shared constants live in ./net.nix.
{ inputs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    inputs.daeuniverse.nixosModules.dae

    ./boot.nix
    ./base.nix
    ./network.nix
    ./proxy.nix
    ./sub-store.nix
    ./sing-box.nix
    ./adguardhome.nix
    ./astrbot.nix
  ];

  system.stateVersion = "26.05";
}
