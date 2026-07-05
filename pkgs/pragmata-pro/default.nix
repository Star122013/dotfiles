# Pragmata Pro — hand-crafted monospace font family by Fabrizio Schiavi
# (https://www.fsd.it). Commercial font; you must own a licence to use it.
#
# Source is the local `PragmataPro.tar.gz` archive at the repo root (must be
# git-tracked for the flake to see it). Run `git add PragmataPro.tar.gz`
# after dropping a new version in.
{
  lib,
  stdenvNoCC,
}:

stdenvNoCC.mkDerivation {
  pname = "pragmata-pro";
  version = "0.829"; # last released line by Fabrizio Schiavi (fsd.it)

  src = ./PragmataPro.tar.gz;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    runHook preInstall

    install -Dm644 ./*.ttf -t $out/share/fonts/truetype/pragmata-pro/

    runHook postInstall
  '';

  meta = with lib; {
    description = "Pragmata Pro — hand-crafted monospace font family for code, screen and print";
    longDescription = ''
      Pragmata Pro is a condensed, hand-crafted monospace font family by
      Fabrizio Schiavi (fsd.it). Designed to fit more information on screen
      while remaining highly legible at small sizes, it ships four core
      styles (Regular, Bold, Italic, Bold Italic / "Z") plus matching
      Powerline-patched variants.
    '';
    homepage = "https://www.fsd.it/shop/fonts/pragmata-pro.php";
    license = licenses.unfree; # commercial
    platforms = platforms.all;
  };
}
