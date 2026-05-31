{ ... }:

{
  perSystem =
    { pkgs, ... }:
    {
      devShells.default = pkgs.mkShell {
        name = "nix devshell";
        buildInputs = with pkgs; [
          nixd
          nixfmt
          statix
          deadnix
        ];
      };
    };
}
