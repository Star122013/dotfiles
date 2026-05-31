{ config, ... }:

{
  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };

    nh = {
      enable = true;
      homeFlake = "${config.home.homeDirectory}/.config/home-manager";
    };
  };
}
