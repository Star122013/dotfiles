# Copyright 2024 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

# scenefx 使用 meson 构建系统
inherit meson

DESCRIPTION="A drop-in replacement for the wlroots scene API with eye-candy effects"
HOMEPAGE="https://github.com/wlrfx/scenefx"

# 如果是 -9999 (Git 版本)
inherit git-r3
EGIT_REPO_URI="https://github.com/wlrfx/scenefx.git"
EGIT_COMMIT="0.4.1"

LICENSE="MIT"
SLOT="0"

DEPEND="
	>=dev-libs/wayland-1.22
	>=x11-libs/pixman-0.42.0
	>=gui-libs/wlroots-0.19.2:=
	media-libs/libglvnd
	x11-libs/libdrm
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"

# Meson eclass 会自动处理 configure, compile, install
# 除非有特殊的配置选项，否则通常不需要写 src_configure
