{ ... }:

let
  templates = {
    nix = {
      path = ../../templates/nix;
      description = "A basic Nix devShell.";
    };

    cpp = {
      path = ../../templates/cpp;
      description = "A basic cpp devShell with cmake.";
    };

    rust = {
      path = ../../templates/rust;
      description = "A basic rust devShell with rust-overlay.";
    };

    md = {
      path = ../../templates/md;
      description = "A basic markdown devShell.";
    };

    zig = {
      path = ../../templates/zig;
      description = "A basic zig devShell using zig-overlay";
    };
  };
in
{
  flake.templates = templates // {
    default = templates.nix;
  };
}
