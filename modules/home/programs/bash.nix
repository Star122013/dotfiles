_:

{
  home.file.".bashrc.d/99-nix-compat.sh".text = ''
    # Nix's bash 5.3 dropped progcomp; silence Fedora compat scripts
    shopt -s progcomp 2>/dev/null || true
  '';
}
