# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="AI CLI Config Switcher for Claude Code, Codex and Gemini API"
HOMEPAGE="https://github.com/farion1231/cc-switch"
EGIT_REPO_URI="https://github.com/farion1231/cc-switch.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""

CRATES=""

inherit cargo git-r3 desktop

# Tauri requires webkit2gtk
DEPEND="
	dev-libs/glib:2
	net-libs/webkit-gtk:4.1
	net-libs/libsoup:3.0
	x11-libs/gtk+:3
	media-libs/fontconfig
	media-libs/libepoxy
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_compile() {
	cargo build --release || die "cargo build failed"
}

src_install() {
	cargo_src_install

	newbin target/release/cc-switch cc-switch

	# Create a simple desktop entry
	cat > cc-switch.desktop << 'EOF' || die
[Desktop Entry]
Name=CC-Switch
Comment=AI CLI Config Switcher
Exec=cc-switch
Icon=cc-switch
Terminal=false
Type=Application
Categories=Utility;
EOF
	domenu cc-switch.desktop

	dodoc README.md
}
