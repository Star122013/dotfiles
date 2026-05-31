# home-manager

Personal Home Manager and dotfiles repository powered by Nix Flakes. It manages the user environment, desktop theming, development tools, application configs, and reusable project templates.

<p align="center">
  <img src="./assets/pic1.jpg" alt="Desktop screenshot 1" width="49%" />
  <img src="./assets/pic2.jpg" alt="Desktop screenshot 2" width="49%" />
</p>

## Overview

This repository manages the `cyrene` user environment with:

- **Home Manager** for user-level configuration
- **flake-parts** for organizing flake outputs
- `home-manager.flakeModules.home-manager` for reusable `homeModules`
- Application configs collected under `dotfiles/`
- Out-of-store symlinks for editable dotfiles
- A set of language-oriented flake templates

## Repository Layout

```text
.
├── assets/                 # README screenshots
├── dotfiles/               # Application configuration files
│   ├── emacs/
│   ├── ghostty/
│   ├── helix/
│   ├── hypr/
│   ├── niri/
│   ├── nushell/
│   ├── nvim/
│   └── vicinae/
├── nix/
│   ├── flake/              # flake-parts modules
│   ├── homeModules/        # Split Home Manager modules
│   ├── lib/                # Local experiments / archived helpers
│   └── templates/          # Flake templates
├── flake.nix
└── flake.lock
```

## Home Manager Modules

The Home Manager configuration is split into `nix/homeModules/`:

```text
nix/homeModules/
├── default.nix
├── core.nix        # User info, session variables, npm prefix, etc.
├── packages.nix    # home.packages
├── desktop.nix     # GTK, cursor, fcitx5, dconf, fontconfig, etc.
├── programs.nix    # direnv, nh, and other program options
└── dotfiles.nix    # Dotfile links
```

The flake currently exposes:

```nix
homeConfigurations.cyrene
homeModules.cyrene
```

## Usage

### Switch the Home Manager Configuration

Using `nh`:

```bash
nh home switch . -c cyrene
```

Or using Home Manager directly:

```bash
home-manager switch --flake .#cyrene
```

### Enter the Development Shell

```bash
nix develop
```

The default development shell includes:

- `nixd`
- `nixfmt`
- `statix`
- `deadnix`

### Update Flake Inputs

```bash
nix flake update
```

## Dotfiles

Application configs live in `dotfiles/` and are linked into `$XDG_CONFIG_HOME` through Home Manager.

Managed configs include:

- `ghostty`
- `helix`
- `nvim`
- `nushell`
- `hypr`
- `niri`
- `vicinae`
- `emacs`
- `go-musicfox`

Most directories are linked through out-of-store symlinks, making it easy to edit files directly inside this repository and have applications pick up changes immediately.

## Desktop and Theming

The configuration includes a Wayland-oriented desktop setup with:

- Niri / Hyprland configuration
- Ghostty / Kitty terminals
- Bibata cursor theme
- Catppuccin GTK theme
- Papirus icon theme
- Sarasa Gothic SC font
- fcitx5 Chinese input method
- Vicinae launcher

## Templates

The repository ships several flake templates:

```text
nix/templates/
├── cpp
├── md
├── nix
├── rust
└── zig
```

Available templates:

```bash
nix flake init -t .#nix
nix flake init -t .#cpp
nix flake init -t .#rust
nix flake init -t .#md
nix flake init -t .#zig
```

Each template is an independent flake with a language-specific devShell and treefmt setup.

## Useful Commands

Show flake outputs:

```bash
nix flake show
```

Check the flake:

```bash
nix flake check --no-build
```

List Home Manager configurations:

```bash
nix eval --json .#homeConfigurations --apply builtins.attrNames
```

List reusable Home Manager modules:

```bash
nix eval --json .#homeModules --apply builtins.attrNames
```

## Notes

This is a personal environment repository. Some values are intentionally hard-coded:

```nix
home.username = "cyrene";
home.homeDirectory = "/var/home/cyrene";
```

If you want to reuse this configuration for another user or machine, adjust these values first.
