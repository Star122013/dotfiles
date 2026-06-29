# Proxy cores: all disabled (sing-box handles everything).
{ pkgs, ... }:

{
  services.mihomo = {
    enable = false;
    configFile = "/etc/mihomo/config.yaml";
    webui = pkgs.metacubexd;
  };
}
