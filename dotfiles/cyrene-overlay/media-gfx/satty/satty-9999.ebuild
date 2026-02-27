# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo git-r3 bash-completion-r1

DESCRIPTION="Modern screenshot annotation tool"
HOMEPAGE="https://github.com/Satty-org/Satty"
EGIT_REPO_URI="https://github.com/Satty-org/Satty.git"

LICENSE="MPL-2.0 Apache-2.0"
SLOT="0"
KEYWORDS=""
IUSE=""

DEPEND="
	dev-libs/glib:2
	gui-libs/gtk:4
	gui-libs/libadwaita
	media-libs/fontconfig
	media-libs/libepoxy
	x11-libs/gdk-pixbuf:2
	x11-libs/pango
"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_compile() {
	cargo_src_compile --bin satty
}

src_install() {
	cargo_src_install --bin satty

	domenu satty.desktop
	doicon assets/satty.svg

	if [[ -f completions/satty.bash ]]; then
		newbashcomp completions/satty.bash satty
	fi

	if [[ -f completions/_satty ]]; then
		insinto /usr/share/zsh/site-functions
		doins completions/_satty
	fi

	if [[ -f completions/satty.fish ]]; then
		insinto /usr/share/fish/vendor_completions.d
		doins completions/satty.fish
	fi

	dodoc README.md
}
