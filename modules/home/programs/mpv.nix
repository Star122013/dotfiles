{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.mpv;
in
{
  options.my.programs.mpv.enable = lib.mkEnableOption "mpv media player";

  config = lib.mkIf cfg.enable {
    # Enabling mpv auto-enables yt-dlp (it's mpv's youtube backend).
    # Set with mkDefault so it can be turned off individually:
    #   my.programs.mpv.enable = true;
    #   my.programs.yt-dlp.enable = false;
    my.programs.yt-dlp.enable = lib.mkDefault true;

    programs.mpv = {
      enable = true;
      config = {
        vo = "gpu-next,gpu";
        hwdec = "auto";
        sub-auto = "fuzzy";
        slang = "zh,chi,eng,en";
        alang = "jpn,eng,en";
        osd-font = "JetBrains Mono";
        sub-font-size = "40";
        sub-scale = "0.8";
      };

      bindings = {
        WHEEL_UP = "add volume 2";
        WHEEL_DOWN = "add volume -2";

        RIGHT = "seek 5";
        LEFT = "seek -5";

        "Ctrl+UP" = "add sub-scale +0.1";
        "Ctrl+DOWN" = "add sub-scale -0.1";
        "Ctrl+RIGHT" = "add sub-delay +0.1";
        "Ctrl+LEFT" = "add sub-delay -0.1";

        j = "cycle sub";
        J = "cycle sub down";
        v = "cycle sub-visibility";

        s = "screenshot";
        S = "screenshot video";
      };

      profiles = {
        youtube = {
          profile-cond = "string.find(path or '', 'youtube') ~= nil";
          cache = "yes";
          cache-secs = 60;
          ytdl-format = "bestvideo+bestaudio";
          hwdec = "auto";
          demuxer-max-bytes = "200M";
          demuxer-max-back-bytes = "100M";
        };
      };
    };
  };
}
