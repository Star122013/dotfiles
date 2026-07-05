{
  config,
  lib,
  ...
}:

let
  cfg = config.my.programs.bash;
in
{
  options.my.programs.bash.enable = lib.mkEnableOption "bash";

  config = lib.mkIf cfg.enable {
    programs.bash = {
      enable = true;
      # Preserve existing behavior: source /etc/bashrc and ~/.bashrc.d/*
      initExtra = ''
        if [ -f /etc/bashrc ]; then
          . /etc/bashrc
        fi

        if [ -d ~/.bashrc.d ]; then
          for rc in ~/.bashrc.d/*; do
            if [ -f "$rc" ]; then
              . "$rc"
            fi
          done
        fi
        unset rc
      '';
    };

    home.file.".bashrc.d/99-nix-compat.sh".text = ''
      # Nix's bash 5.3 dropped progcomp; silence Fedora compat scripts
      shopt -s progcomp 2>/dev/null || true
    '';
  };
}
