# Router services: DNS/DHCP, proxy stack, and podman workloads.
{ ... }:

{
  imports = [
    ./adguardhome.nix
    ./sing-box.nix
    ./dae.nix
    ./sub-store.nix
    ./astrbot.nix
  ];
}
