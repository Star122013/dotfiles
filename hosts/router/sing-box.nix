# sing-box: 读 /etc/sing-box 目录下所有 json 自动合并运行.
# base.json / node.json 以及定时拉取脚本由你手动放在 /etc/sing-box.
{ lib, pkgs, ... }:

let
  configDir = "/etc/singbox";
  singboxGid = 999;
in
{
  users.groups.singbox = {
    name = "singbox";
    gid = singboxGid;
  };

  users.users.singbox = {
    name = "singbox";
    uid = singboxGid;
    group = "singbox";
    isSystemUser = true;
  };

  systemd.tmpfiles.rules = [
    "d ${configDir} 0750 singbox singbox -"
  ];

  systemd.services.sing-box = {
    description = "sing-box";
    after = [ "network-online.target" "adguardhome.service" ];
    wants = [ "network-online.target" "adguardhome.service" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      ExecStart = "${lib.getExe pkgs.sing-box} run -C ${configDir}";
      WorkingDirectory = configDir;
      User = "singbox";
      Group = "singbox";
      Restart = "on-failure";
      RestartSec = 5;
      AmbientCapabilities = [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
      ];
      CapabilityBoundingSet = [
        "CAP_NET_ADMIN"
        "CAP_NET_BIND_SERVICE"
      ];
    };
  };

  # 每天 7 点从路由器 SubStore 拉取节点配置并重启 sing-box
  systemd.services.sing-box-update = {
    description = "Update sing-box node config from router SubStore";
    after = [ "network-online.target" "sing-box.service" ];
    wants = [ "network-online.target" ];
    path = [ pkgs.curl ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.curl}/bin/curl -s -f -o /etc/singbox/node.json 'http://10.10.10.1:3001/qwerhyy123/download/collection/singbox?target=sing-box'";
      ExecStartPost = "${pkgs.systemd}/bin/systemctl try-restart sing-box.service";
    };
  };

  systemd.timers.sing-box-update = {
    wantedBy = [ "timers.target" ];
    timerConfig = {
      OnCalendar = "07:00";
      Persistent = true;
    };
  };

  environment.systemPackages = [ pkgs.sing-box ];
  environment.etc."/singbox/base.json" = {
    source = ./assets/singbox-base.json;
  };

}
