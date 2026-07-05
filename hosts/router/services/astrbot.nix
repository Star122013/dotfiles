# AstrBot + NapCatQQ + Shipyard Neo 沙盒: AI chatbot with QQ adapter, under podman.
#
# 四个容器共享自定义 bridge 网络 "astrbot_network"：
#   - astrbot: AI 聊天核心
#   - napcat: QQ 适配器 (OneBot v11)
#   - bay: Shipyard Neo 控制面 API (沙盒编排)
#   - gull-service: 共享浏览器池 (供 browser-python profile 使用)
#
# Bay 通过 /var/run/docker.sock 动态创建 Ship/Gull 沙箱容器。
# AstrBot 通过共享 bay-data 卷自动发现 Bay 的 API key。
#
# 端口:
#   AstrBot WebUI  : 6185
#   NapCat  WebUI  : 6099
#   Bay     API    : 8114
#
# NapCat WebUI 地址: http://10.10.10.1:6099/webui
# NapCat 默认登录 Token: napcat (通过 `podman logs napcat` 查看)
# AstrBot WebUI 地址: http://10.10.10.1:6185
# AstrBot 初始密码: 见 `podman logs astrbot`
#
# 沙盒配置 (AstrBot WebUI → AI Settings → Agent Computer Use):
#   Computer Use Runtime = sandbox
#   Sandbox Driver       = Shipyard Neo
#   Shipyard Neo API Endpoint = http://bay:8114
#   Shipyard Neo Access Token = 留空 (自动从 bay-data 卷发现)
#
# 参考:
#   - https://docs.astrbot.app/en/deploy/astrbot/docker.html
#   - https://docs.astrbot.app/en/use/astrbot-agent-sandbox.html
#   - https://github.com/NapNeko/NapCat-Docker/blob/main/compose/astrbot.yml
#   - https://github.com/AstrBotDevs/shipyard-neo
{ pkgs, ... }:
let
  # 持久化数据目录
  astrbotDataDir = "/var/lib/astrbot";
  napcatConfigDir = "/var/lib/napcat/config";
  napcatQQDir = "/var/lib/napcat/ntqq";
  bayDataDir = "/var/lib/astrbot/bay-data";
  bayCargosDir = "/var/lib/astrbot/bay-cargos";
  # 容器共享的 podman 网络
  networkName = "astrbot_network";
  # 宿主机上 NapCat 容器进程的 uid/gid
  napcatUid = 1000;
  napcatGid = 1000;
  # Bay 配置文件路径
  bayConfigFile = "/var/lib/astrbot/bay-config.yaml";
in
{
  # ---------- podman docker socket ----------
  # Bay 需要通过 Docker socket 动态创建沙箱容器
  virtualisation.podman.dockerSocket.enable = true;
  # ---------- 容器 ----------
  # (podman 已在 sub-store.nix 中启用)
  virtualisation.oci-containers.containers = {
    astrbot = {
      image = "docker.io/soulter/astrbot:latest";
      autoStart = true;
      autoRemoveOnStop = false;
      pull = "always";
      ports = [ "6185:6185" ];
      volumes = [
        "${astrbotDataDir}:/AstrBot/data"
        # 挂载 bay-data 卷让 AstrBot 自动发现 Bay 的 API key
        "${bayDataDir}:/bay-data:ro"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        TZ = "Asia/Shanghai";
        BAY_DATA_DIR = "/bay-data";
      };
      extraOptions = [
        "--name=astrbot"
        "--network=${networkName}"
        "--restart=always"
      ];
    };
    napcat = {
      image = "docker.io/mlikiowa/napcat-docker:latest";
      autoStart = true;
      autoRemoveOnStop = false;
      ports = [ "6099:6099" ];
      volumes = [
        "${astrbotDataDir}:/AstrBot/data"
        "${napcatConfigDir}:/app/napcat/config"
        "${napcatQQDir}:/app/.config/QQ"
        "/etc/localtime:/etc/localtime:ro"
      ];
      environment = {
        NAPCAT_UID = toString napcatUid;
        NAPCAT_GID = toString napcatGid;
        MODE = "astrbot";
      };
      extraOptions = [
        "--name=napcat"
        "--network=${networkName}"
        "--restart=always"
      ];
    };
    # Shipyard Neo: 共享浏览器池
    gull-service = {
      image = "ghcr.io/astrbotdevs/shipyard-neo-gull:latest";
      autoStart = true;
      autoRemoveOnStop = false;
      pull = "always";
      volumes = [
        "${bayCargosDir}:/cargos:ro"
      ];
      environment = {
        GULL_MODE = "shared";
        GULL_CDP_PORT = "9222";
        AGENT_BROWSER_IDLE_TIMEOUT_MS = "600000";
      };
      extraOptions = [
        "--name=bay-gull"
        "--network=${networkName}"
        "--restart=always"
      ];
    };
    # Shipyard Neo: Bay 控制面 API
    bay = {
      image = "ghcr.io/astrbotdevs/shipyard-neo-bay:latest";
      autoStart = true;
      autoRemoveOnStop = false;
      pull = "always";
      ports = [ "8114:8114" ];
      volumes = [
        "/var/run/docker.sock:/var/run/docker.sock"
        "${bayConfigFile}:/app/config.yaml:ro"
        "${bayDataDir}:/app/data"
        "${bayCargosDir}:/var/lib/bay/cargos"
      ];
      environment = {
        BAY_CONFIG_FILE = "/app/config.yaml";
        BAY_DATA_DIR = "/app/data";
      };
      extraOptions = [
        "--name=bay"
        "--network=${networkName}"
        "--restart=always"
      ];
    };
  };
  # ---------- systemd ----------
  systemd = {
    tmpfiles.rules = [
      "d ${astrbotDataDir} 0755 ${toString napcatUid} ${toString napcatGid} -"
      "d ${astrbotDataDir}/temp 0755 ${toString napcatUid} ${toString napcatGid} -"
      "d ${napcatConfigDir} 0755 ${toString napcatUid} ${toString napcatGid} -"
      "d ${napcatQQDir} 0755 ${toString napcatUid} ${toString napcatGid} -"
      "d ${bayDataDir} 0755 root root -"
      "d ${bayCargosDir} 0755 root root -"
    ];
    services = {
      podman-network-astrbot = {
        description = "Create podman network for AstrBot + NapCat + Shipyard";
        after = [ "podman.service" ];
        wants = [ "podman.service" ];
        wantedBy = [ "multi-user.target" ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${pkgs.podman}/bin/podman network create --ignore ${networkName}";
          ExecStop = "${pkgs.podman}/bin/podman network rm --force ${networkName}";
        };
      };
      # Bay 配置文件：从 assets/bay-config.yaml 复制
      podman-bay-config = {
        description = "Create Shipyard Neo Bay config if missing";
        after = [ "network-online.target" ];
        wants = [ "network-online.target" ];
        wantedBy = [ "multi-user.target" ];
        path = [ pkgs.coreutils ];
        script = ''
          if [ ! -f ${bayConfigFile} ]; then
            cp ${../assets/bay-config.yaml} ${bayConfigFile}
            chmod 600 ${bayConfigFile}
          fi
        '';
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
        };
      };
      # 服务依赖
      podman-astrbot = {
        after = [
          "network-online.target"
          "podman-network-astrbot.service"
          "podman-bay-config.service"
        ];
        wants = [
          "network-online.target"
          "podman-network-astrbot.service"
          "podman-bay-config.service"
        ];
      };
      podman-napcat = {
        after = [
          "network-online.target"
          "podman-network-astrbot.service"
        ];
        wants = [
          "network-online.target"
          "podman-network-astrbot.service"
        ];
      };
      podman-gull-service = {
        after = [
          "network-online.target"
          "podman-network-astrbot.service"
        ];
        wants = [
          "network-online.target"
          "podman-network-astrbot.service"
        ];
      };
      podman-bay = {
        after = [
          "network-online.target"
          "podman-network-astrbot.service"
          "podman-bay-config.service"
        ];
        wants = [
          "network-online.target"
          "podman-network-astrbot.service"
          "podman-bay-config.service"
        ];
      };
    };
  };
}
