_: {
  programs.mpv = {
    enable = true;
    config = {
      vo = "gpu-next,gpu";
      hwdec = "auto";
      ytdl-format = "bestvideo+bestaudio";
      cache-default = 4000000;
      sub-auto = "fuzzy";
      slang = "zh,chi,eng,en";
      alang = "jpn,eng,en";
      osd-font = "JetBrains Mono";
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
        demuxer-max-bytes = "200M";
        demuxer-max-back-bytes = "100M";
      };
    };
  };
}
