#!/bin/bash
# Gentoo install script for Exo (debuggyo/Exo)
# This script handles dependencies for Gentoo and then runs the official installer.

set -e

echo "=== Exo Installer for Gentoo ==="

# Function to check command existence
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# 1. System Dependencies via Portage
echo "Checking system dependencies..."
DEPS=(
    "dev-vcs/git"
    "dev-lang/python"
    "dev-python/pip"
    "dev-util/pkgconf"
    "dev-libs/wayland-protocols"
    "dev-libs/gobject-introspection"
    "dev-libs/libadwaita" # For GTK4/Adwaita support
    "gui-libs/gtk:4"
    "net-wireless/gnome-bluetooth"
)

MISSING_DEPS=()
for dep in "${DEPS[@]}"; do
    if ! qlist -I "$dep" >/dev/null 2>&1; then
        # Simple check, might need better atom parsing
        # Try emerge -p to check installed status more reliably?
        # For now, just warn or try emerge.
        echo "Checking $dep..."
    fi
done

echo "Installing missing system dependencies (if any)..."
# Using --noreplace to avoid reinstalling
sudo emerge --noreplace "${DEPS[@]}" || echo "Warning: Some system dependencies might be missing or failed to install."

# 2. Rust/Cargo Tools (matugen, swww)
if ! command_exists cargo; then
    echo "Installing Rust/Cargo..."
    sudo emerge dev-lang/rust-bin || sudo emerge dev-lang/rust
fi

if ! command_exists matugen; then
    echo "Installing matugen..."
    # Check if available in overlay first
    if emerge --search matugen | grep -q "matugen"; then
        sudo emerge matugen
    else
        cargo install matugen
    fi
fi

if ! command_exists swww; then
    echo "Installing swww..."
    if emerge --search swww | grep -q "swww"; then
        sudo emerge swww
    else
        # swww needs wayland-protocols and pkg-config
        cargo install --git https://github.com/LGFae/swww.git
    fi
fi

# 3. Python/Pip Tools (ignis)
if ! python3 -c "import ignis" 2>/dev/null; then
    echo "Installing ignis..."
    # Using pip install --user to avoid breaking system python
    pip install --user --break-system-packages git+https://github.com/ignis-sh/ignis.git
fi

# 4. Sass
if ! command_exists sass; then
    echo "Installing sass..."
    if command_exists npm; then
        npm install -g sass
    else
        sudo emerge dev-lang/sass || echo "Please install sass manually."
    fi
fi

# 5. Clone and Run Exo Installer
TEMP_DIR=$(mktemp -d)
echo "Cloning Exo to $TEMP_DIR..."
git clone --depth 1 https://github.com/debuggyo/Exo "$TEMP_DIR/Exo"

echo "Running official Exo installer..."
cd "$TEMP_DIR/Exo"
# Run with python3
./exoinstall.py

echo "Cleaning up..."
rm -rf "$TEMP_DIR"

echo "Exo installation complete! Please restart your session or reload config."
