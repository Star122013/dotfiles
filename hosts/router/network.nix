# Networking: networkd (WAN/LAN + NAT), DNS hijack (AdGuard Home).
# Transparent proxy is handled by dae via eBPF; no nftables TProxy here.
_:

let
  net = import ./net.nix;
in
{
  networking = {
    enableIPv6 = false;
    networkmanager.enable = false;
    useDHCP = false;
    resolvconf.useLocalResolver = false;
    firewall.enable = false;
    nameservers = [ "127.0.0.1" ];
  };

  services.resolved.enable = false;

  systemd = {
    network = {
      enable = true;
      networks = {
        "10-wan" = {
          matchConfig.Name = net.wanInterface;
          networkConfig = {
            Description = "WAN";
            DHCP = "yes";
          };
        };

        "10-lan" = {
          matchConfig.Name = net.lanInterface;
          networkConfig = {
            Description = "LAN (USB NIC)";
            Address = net.lanAddress;
            IPMasquerade = "both";
          };
          linkConfig.RequiredForOnline = true;
        };
      };
    };

    services.systemd-resolved = {
      enable = false;
      unitConfig.ConditionPathExists = "/nonexistent";
    };
  };

  networking.nftables = {
    enable = true;
    tables = {
      # WAN 防火墙：只放行已建立的连接和 LAN 发起的流量
      filter = {
        enable = true;
        name = "filter";
        family = "inet";
        content = ''
          chain input {
            type filter hook input priority 0; policy accept;

            ct state { established, related } accept
            iifname "lo" accept
            iifname ${net.lanInterface} accept
            iifname ${net.wanInterface} drop
          }

          chain forward {
            type filter hook forward priority 0; policy accept;

            ct state { established, related } accept
            iifname ${net.lanInterface} oifname ${net.wanInterface} accept
            iifname ${net.wanInterface} drop
          }
        '';
      };

      # DNS 劫持：LAN 上任何发往非 AGH 的 DNS 查询 → 重定向到 AGH
      # 防止客户端手动改 DNS 绕过广告过滤和分流。
      dns-nat = {
        enable = true;
        name = "dns-nat";
        family = "inet";
        content = ''
          chain prerouting {
            type nat hook prerouting priority -100; policy accept;

            iifname ${net.lanInterface} udp dport 53 ip daddr != ${net.lanIp} redirect to 53
            iifname ${net.lanInterface} tcp dport 53 ip daddr != ${net.lanIp} redirect to 53
          }
        '';
      };
    };
  };
}
