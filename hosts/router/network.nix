# Networking: networkd (WAN/LAN + NAT), DNS+DHCP (AdGuard Home), proxy (sing-box).
{ pkgs, ... }:

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

    services = {
      systemd-resolved = {
        enable = false;
        unitConfig.ConditionPathExists = "/nonexistent";
      };

      iproute-singbox = {
        enable = true;
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.iproute2 ];
        script = ''
          grep -q "^100 singbox$" /etc/iproute2/rt_tables || echo "100 singbox" >> /etc/iproute2/rt_tables

          ip -4 rule add fwmark 1 lookup singbox priority 100 2>/dev/null || true
          ip -4 route add local 0.0.0.0/0 dev lo table singbox 2>/dev/null || true
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = "yes";
        };
      };
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

      singbox = {
        enable = true;
        name = "singbox";
        family = "inet";
        content = ''
          chain prerouting {
            type filter hook prerouting priority -150; policy accept;

            meta mark 1234 accept                               # sing-box 已处理的跳过
            ip daddr { 127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } accept
            ip6 daddr { ::1, fc00::/7 } accept                  # 私有地址直连

            meta l4proto tcp meta mark set 1 tproxy to :12345 accept   # 所有 TCP → TProxy + 打标记
            udp dport 443 drop;                                 # 禁用 QUIC/HTTP3
          }
          chain output {
            type route hook output priority -150; policy accept;

            meta mark 1234 accept                               # Sing-Box 已处理的跳过
            skgid == 999 accept                                 # Sing-Box 用户组流量跳过
            ip daddr { 127.0.0.0/8, 10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16 } accept  # 私有地址直连
            meta l4proto tcp meta mark set 1 accept             # 其他 TCP 打标记 → lo → PREROUTING TProxy
          }
        '';
      };
    };
  };
  networking.iproute2 = {
    enable = true;
    rttablesExtraConfig = "100 singbox";
  };
}
