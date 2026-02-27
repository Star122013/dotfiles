EAPI=8

inherit meson git-r3

DESCRIPTION="A wm based on dwl(no suckless)"
HOMEPAGE="https://github.com/DreamMaoMao/mangowc"

EGIT_REPO_URI="https://github.com/DreamMaoMao/mangowc.git"
LICENSE="MIT"
SLOT="0"
IUSE=""

DEPEND="
	app-alternatives/ninja
	dev-build/meson
	virtual/pkgconfig
	dev-libs/libinput
	x11-misc/xcb
	dev-libs/wayland
	=gui-libs/scenefx-9999
	gui-libs/wlroots
	x11-libs/pixman
	x11-base/xwayland
"
RDEPEND="${DEPEND}"
BDEPEND="
	dev-util/wayland-scanner
	virtual/pkgconfig
"
