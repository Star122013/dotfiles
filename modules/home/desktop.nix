# Desktop module group — parent toggle.
#
# Enabling `my.desktop` turns on every desktop sub-module (appearance, fonts,
# stylix) by default. Because the defaults are set with `mkDefault`, any
# sub-module can be individually disabled even while the group is on —
# a NAND-style override:
#
#   my.desktop.enable = true;            # enables appearance + fonts + stylix
#   my.desktop.fonts.enable = false;     # …but skip fonts
#
# Inter-module dependency: enabling stylix also pulls in fonts, because
# Stylix references font names that fonts.nix must install. This is expressed
# with mkDefault too, so it stays overridable.
#
# The sub-modules themselves live in ./desktop/ and are auto-imported by
# importDir; each gates its config behind its own `my.desktop.<name>.enable`.
{
  config,
  lib,
  ...
}:

let
  cfg = config.my.desktop;
in
{
  options.my.desktop = {
    enable = lib.mkEnableOption "desktop module group (appearance, fonts, stylix)";

    # Centralised, easy-to-change theme knobs. Sub-modules read these so the
    # font names live in one place rather than being duplicated across
    # fonts.nix and stylix.nix.
    fonts = {
      monospace = lib.mkOption {
        type = lib.types.str;
        default = "Iosevka Mono Custom";
        description = "Primary monospace font name (must be installed by the fonts module).";
      };
      monospaceFallback = lib.mkOption {
        type = lib.types.str;
        default = "LXGW WenKai Mono";
        description = "Fallback monospace font for CJK glyphs.";
      };
      serif = lib.mkOption {
        type = lib.types.str;
        default = "LXGW WenKai Screen";
        description = "Serif / sans-serif font name.";
      };
      sansSerif = lib.mkOption {
        type = lib.types.str;
        default = "LXGW WenKai Screen";
        description = "Sans-serif font name.";
      };
      emoji = lib.mkOption {
        type = lib.types.str;
        default = "Noto Color Emoji";
        description = "Emoji font name.";
      };
      terminalSize = lib.mkOption {
        type = lib.types.int;
        default = 16;
        description = "Terminal font size (pt).";
      };
    };

    base16Scheme = lib.mkOption {
      type = lib.types.str;
      default = "onedark";
      description = "Base16 color scheme name (without .yaml suffix), resolved via pkgs.base16-schemes.";
    };
  };

  config = lib.mkIf cfg.enable {
    # Parent → children (each overridable via NAND).
    #
    # stylix references font names that the fonts module must install, so the
    # stylix module itself pulls in fonts via its own mkDefault (see
    # stylix.nix). Here we only set the three group defaults.
    my.desktop = {
      appearance.enable = lib.mkDefault true;
      fonts.enable = lib.mkDefault true;
      stylix.enable = lib.mkDefault true;
    };
  };
}
