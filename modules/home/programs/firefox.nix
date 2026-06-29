{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.firefox;
in
{
  options.my.programs.firefox.enable = lib.mkEnableOption "Firefox browser";

  config = lib.mkIf cfg.enable {
    programs.firefox = {
      enable = true;
      profiles.default-release = {
        id = 0;
        path = "toq0r65u.default-release";
        settings = {
          "media.hardware-video-decoding.enabled" = true;
          "media.ffmpeg.vaapi.enabled" = true;
          "media.rdd-ffmpeg.enabled" = true;
          "media.ffvpx.enabled" = false;
        };
      };
    };
  };
}
