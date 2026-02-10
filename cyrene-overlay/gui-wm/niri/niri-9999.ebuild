# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

CRATES="
"

inherit cargo git-r3 systemd bash-completion-r1

# 使用 CLI git 命令拉取依赖，避免 libgit2 在某些网络环境下（如代理）拉取 git 依赖失败
export CARGO_NET_GIT_FETCH_WITH_CLI=true

DESCRIPTION="A scrollable-tiling Wayland compositor"
HOMEPAGE="https://github.com/YaLTeR/niri"
EGIT_REPO_URI="https://github.com/YaLTeR/niri.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS=""
IUSE="systemd"

# Niri 依赖说明:
# - clang: 用于 bindgen (wayland-sys, libseat-sys 等)
# - pango/cairo: 用于字体渲染
# - seatd/libseat: 用于会话管理
# - mesa[gbm]: 用于缓冲区管理
DEPEND="
	dev-libs/glib:2
	dev-libs/wayland
	media-libs/libdisplay-info
	media-libs/mesa
	sys-auth/seatd
	virtual/libudev
	x11-libs/cairo
	dev-libs/libinput
	x11-libs/libxkbcommon
	x11-libs/pango
	x11-libs/pixman
"
RDEPEND="${DEPEND}
	x11-misc/xkeyboard-config
"
BDEPEND="
	dev-libs/wayland-protocols
	llvm-core/clang
	virtual/pkgconfig
"

# 显式定义 src_unpack 和 src_configure 以确保 cargo 配置正确生成
src_unpack() {
	git-r3_src_unpack
	cargo_live_src_unpack
}

src_configure() {
	cargo_src_configure --frozen
}

src_compile() {
	cargo build --release

	"$(cargo_target_dir)"/niri completions bash > niri  || die
	"$(cargo_target_dir)"/niri completions fish > niri.fish || die
	"$(cargo_target_dir)"/niri completions zsh > _niri || die
}

src_install() {
	cargo_src_install

	if use systemd; then
		dobin resources/niri-session
		systemd_douserunit resources/niri{.service,-shutdown.target}
	else
		sed -i 's/Exec=niri-session/Exec=niri/' resources/niri.desktop || die
	fi

	insinto /usr/share/wayland-sessions
	doins resources/niri.desktop

	insinto /usr/share/xdg-desktop-portal
	doins resources/niri-portals.conf

	dobashcomp niri
	insinto /usr/share/fish/vendor_completions.d
	doins niri.fish
	insinto /usr/share/zsh/site-functions
	doins _niri
}


