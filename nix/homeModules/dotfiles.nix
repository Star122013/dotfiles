{ config, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
  dotfilesDir = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
in
{
  xdg.configFile."niri/config".source = mkOutOfStoreSymlink "${dotfilesDir}/niri/config";
  xdg.configFile."niri/colors".source = mkOutOfStoreSymlink "${dotfilesDir}/niri/colors";
  xdg.configFile."niri/config.kdl".source = mkOutOfStoreSymlink "${dotfilesDir}/niri/config.kdl";
  xdg.configFile."hypr/hyprland.lua".source = mkOutOfStoreSymlink "${dotfilesDir}/hypr/hyprland.lua";
  xdg.configFile."hypr/modules".source = mkOutOfStoreSymlink "${dotfilesDir}/hypr/modules";
  xdg.configFile."ghostty".source = mkOutOfStoreSymlink "${dotfilesDir}/ghostty";
  xdg.configFile."helix".source = mkOutOfStoreSymlink "${dotfilesDir}/helix";
  xdg.configFile."nvim".source = mkOutOfStoreSymlink "${dotfilesDir}/nvim";
  xdg.configFile."nushell/env.nu".source = mkOutOfStoreSymlink "${dotfilesDir}/nushell/env.nu";
  xdg.configFile."nushell/config.nu".source = mkOutOfStoreSymlink "${dotfilesDir}/nushell/config.nu";
  xdg.configFile."vicinae/settings.json".source =
    mkOutOfStoreSymlink "${dotfilesDir}/vicinae/settings.json";
  xdg.configFile."emacs/init.el".source = mkOutOfStoreSymlink "${dotfilesDir}/emacs/init.el";
  xdg.configFile."go-musicfox/config.toml".source =
    mkOutOfStoreSymlink "${dotfilesDir}/go-musicfox/config.toml";
}
