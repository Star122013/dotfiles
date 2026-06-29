{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  cfg = config.my.programs.emacs;
  dotfilesDir = "${config.home.homeDirectory}/.config/home-manager/dotfiles";
in
{
  options.my.programs.emacs.enable = lib.mkEnableOption "Emacs";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      inputs.emacs.packages.${stdenv.hostPlatform.system}.emacs-unstable-pgtk
    ];

    xdg.configFile."emacs/init.el".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/init.el";
    xdg.configFile."emacs/early-init.el".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/early-init.el";
    xdg.configFile."emacs/extras".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/extras";
    xdg.configFile."emacs/assets".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/assets";
    xdg.configFile."emacs/user-lisp".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/user-lisp";
  };
}
