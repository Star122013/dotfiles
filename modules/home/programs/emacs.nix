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

    xdg.configFile = {
      "emacs/init.el".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/init.el";
      "emacs/early-init.el".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/early-init.el";
      "emacs/extras".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/extras";
      "emacs/assets".source = config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/assets";
      "emacs/user-lisp/extras-base.el".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/user-lisp/extras-base.el";
      "emacs/user-lisp/extras-dev.el".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/user-lisp/extras-dev.el";
      "emacs/user-lisp/extras-org.el".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/user-lisp/extras-org.el";
      "emacs/user-lisp/extras-ui.el".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/user-lisp/extras-ui.el";
      "emacs/user-lisp/lang-config.el".source =
        config.lib.file.mkOutOfStoreSymlink "${dotfilesDir}/emacs/user-lisp/lang-config.el";

    };
  };
}
