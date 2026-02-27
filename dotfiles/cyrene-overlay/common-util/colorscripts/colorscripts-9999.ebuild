# Copyright 1999-2026 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

inherit git-r3

DESCRIPTION="Collection of terminal color scripts"
HOMEPAGE="https://gitlab.com/dwt1/shell-color-scripts"
EGIT_REPO_URI="https://gitlab.com/dwt1/shell-color-scripts.git"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="app-shells/bash"

src_install() {
	newbin colorscript.sh colorscript

	exeinto /opt/shell-color-scripts/colorscripts
	doexe colorscripts/*

	if [[ -f completions/_colorscript ]]; then
		insinto /usr/share/zsh/site-functions
		doins completions/_colorscript
	fi

	if [[ -f completions/colorscript.fish ]]; then
		insinto /usr/share/fish/vendor_completions.d
		doins completions/colorscript.fish
	fi

	dodoc README.md
}
