# Copyright 1999-2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit cargo git-r3

DESCRIPTION="Nix dependency pinning. Very similar to Niv"
HOMEPAGE="https://github.com/andir/npins"
EGIT_REPO_URI="https://github.com/andir/npins.git"

LICENSE="EUPL-1.2"
SLOT="0"
KEYWORDS=""
IUSE=""

# Rust 程序通常依赖 OpenSSL，保险起见加入依赖
DEPEND="dev-libs/openssl"
RDEPEND="${DEPEND}"
BDEPEND="virtual/pkgconfig"

src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_compile() {
	cargo build --release
}
