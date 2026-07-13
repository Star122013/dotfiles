{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:

let
  desktop = config.my.desktop;
  cfg = config.my.desktop.fonts;
  system = pkgs.stdenv.hostPlatform.system;
  pragmataPro = pkgs.callPackage ../../../pkgs/pragmata-pro { };
in
{
  options.my.desktop.fonts.enable = lib.mkEnableOption "font packages and fontconfig";

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      lxgw-wenkai
      sarasa-gothic
      maple-mono.NF-CN
      ioskeley-mono.normal-NF
      nerd-fonts.symbols-only
      noto-fonts-color-emoji
      noto-fonts-lgc-plus
      noto-fonts
      font-awesome
      lxgw-wenkai-screen
      pragmataPro
      inputs.iosevka.packages.${system}.default
      inputs.iosevka.packages.${system}.normal
      inputs.iosevka.packages.${system}.mono
    ];

    fonts.fontconfig = {
      enable = true;
      defaultFonts.monospace = [
        desktop.fonts.monospace
        desktop.fonts.monospaceFallback
      ];
      defaultFonts.emoji = [
        desktop.fonts.emoji
      ];
    };

    # Reject the COLRv1 variant of Noto Color Emoji shipped by Fedora 43+
    # which does not render properly in Ghostty and other applications.
    # See https://github.com/ghostty-org/ghostty/discussions/12667
    xdg.configFile."fontconfig/conf.d/50-reject-colrv1.conf".text = ''
      <?xml version="1.0"?>
      <!DOCTYPE fontconfig SYSTEM "urn:fontconfig:fonts.dtd">
      <fontconfig>
        <description>Reject COLRv1 format Noto Color Emoji (renders blank in many apps)</description>
        <selectfont>
          <rejectfont>
            <glob>/usr/share/fonts/**/*COLRv1*</glob>
          </rejectfont>
        </selectfont>
      </fontconfig>
    '';
  };
}
