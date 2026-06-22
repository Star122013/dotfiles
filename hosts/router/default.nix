# Router machine profile.
{
  lib,
  pkgs,
  inputs,
  ...
}:

let
  lanIp = "10.10.10.1";
  lanAddress = "${lanIp}/24";
  lanInterface = "enp0s20f0u1";
  wanInterface = "eno1";
  username = "cyrene";
  sshAuthorizedKey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIIol2jOtpYtP1udDTCzd/0qGvQt+WoZnU6tfULAalbA4";
  lanDevice = "sys-subsystem-net-devices-${lanInterface}.device";
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.daeuniverse.nixosModules.dae
  ];

  # =================== Boot / firmware ===================
  boot = {
    loader = {
      systemd-boot.enable = true;
      efi.canTouchEfiVariables = true;
    };
    blacklistedKernelModules = [ "r8153_ecm" ];

    kernel.sysctl."net.ipv4.ip_forward" = 1;
    kernelModules = [ "nft_tproxy" ];
  };

  services.udev.extraRules = ''
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1d6b", ATTR{idProduct}=="0002", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="1d6b", ATTR{idProduct}=="0003", ATTR{power/control}="on"
    ACTION=="add", SUBSYSTEM=="usb", ATTR{idVendor}=="0bda", ATTR{idProduct}=="8153", ATTR{power/control}="on"
  '';

  # =================== Base system ===================
  networking.hostName = "nixos-router";
  time.timeZone = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  users.users.${username} = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    packages = with pkgs; [
      tree
      neovim
      helix
      fastfetch
      nixd
      eza
    ];
  };

  users.users.root.openssh.authorizedKeys.keys = [ sshAuthorizedKey ];

  environment.systemPackages = with pkgs; [
    vim
    wget
    git
    nixd
    nixfmt
    usbutils
    pciutils
    pi-coding-agent
    nodejs-slim
    nodejs-slim.npm
    fastfetch
  ];

  services.openssh = {
    enable = true;
    settings.PermitRootLogin = "prohibit-password";
  };

  nix.settings = {
    experimental-features = [
      "nix-command"
      "flakes"
      "pipe-operators"
    ];
    extra-substituters = [ "https://mirror.sjtu.edu.cn/nix-channels/store" ];
  };
  nixpkgs.config.allowUnfree = true;

  # =================== Networking (networkd + NAT) ===================
  networking = {
    enableIPv6 = false;
    networkmanager.enable = false;
    useDHCP = false;
    resolvconf.useLocalResolver = true;
    firewall.enable = false;
  };

  systemd.network = {
    enable = true;
    networks = {
      "10-wan" = {
        matchConfig.Name = wanInterface;
        networkConfig = {
          Description = "WAN";
          DHCP = "yes";
        };
      };

      "10-lan" = {
        matchConfig.Name = lanInterface;
        networkConfig = {
          Description = "LAN (USB NIC)";
          Address = lanAddress;
          IPMasquerade = "both";
        };
        linkConfig.RequiredForOnline = true;
      };
    };
  };

  # =================== DHCP (kea dhcp4) ===================
  services.kea.dhcp4 = {
    enable = true;
    settings = {
      interfaces-config.interfaces = [ lanInterface ];
      subnet4 = [
        {
          id = 1;
          subnet = lanAddress;
          pools = [ { pool = "10.10.10.2 - 10.10.10.100"; } ];
          option-data = [
            {
              name = "routers";
              data = lanIp;
            }
            {
              name = "domain-name-servers";
              data = lanIp;
            }
          ];
        }
      ];
      lease-database = {
        name = "/var/lib/kea/dhcp4.leases";
        persist = true;
        type = "memfile";
      };
      valid-lifetime = 4000;
    };
  };

  systemd.services.kea-dhcp4-server = {
    after = [
      lanDevice
      "network-online.target"
    ];
    bindsTo = [ lanDevice ];
    wants = [ "network-online.target" ];
  };

  # =================== DNS (unbound) ===================
  services.unbound = {
    enable = true;
    enableRootTrustAnchor = false;
    settings = {
      server = {
        interface = [
          lanIp
          "127.0.0.1"
        ];
        access-control = [
          "${lanAddress} allow"
          "127.0.0.0/8 allow"
        ];
        do-ip4 = true;
        do-ip6 = false;
        do-udp = true;
        do-tcp = true;
        hide-identity = true;
        hide-version = true;
        prefetch = true;
        cache-min-ttl = 3600;
        cache-max-ttl = 86400;
        verbosity = 1;
        val-permissive-mode = true;
      };
      forward-zone = [
        {
          name = ".";
          forward-addr = [
            "223.5.5.5"
            "119.29.29.29"
          ];
        }
      ];
    };
  };

  systemd.services.unbound = {
    after = [
      lanDevice
      "network-online.target"
    ];
    wants = [ "network-online.target" ];
  };

  services.resolved.enable = false;
  systemd.services.systemd-resolved = {
    enable = false;
    unitConfig.ConditionPathExists = "/nonexistent";
  };

  # =================== dae ===================
  services.dae = {
    enable = true;
    package = inputs.daeuniverse.packages.x86_64-linux.dae;
    configFile = "/etc/dae/config.dae";
    openFirewall = {
      enable = true;
      port = 12345;
    };
    assets = with pkgs; [
      v2ray-geoip
      v2ray-domain-list-community
    ];
  };
  systemd.services.dae = {
    after = [
      lanDevice
      "unbound.service"
      "network-online.target"
    ];
    wants = [
      lanDevice
      "network-online.target"
    ];
    requires = [ "unbound.service" ];
  };
  environment.etc."/dae/config.dae" = {
    source = ./assets/dae.dae;
    mode = "0600";
  };

  # =================== mihomo ===================
  services.mihomo = {
    enable = true;
    configFile = "/etc/mihomo/config.yaml";
    webui = pkgs.metacubexd;
  };

  system.stateVersion = "26.05";
}
