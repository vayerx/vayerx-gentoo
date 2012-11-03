# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils games git-2

DESCRIPTION="The main game for the Minetest game engine."
HOMEPAGE="http://github.com/celeron55/minetest_game/"

EGIT_REPO_URI="git://github.com/celeron55/minetest_game.git"

KEYWORDS="~x86 ~amd64"

if [[ "${PV}" != 9999* ]]; then
	EGIT_COMMIT="${PV}"
fi

SRC_URI=""
S="${WORKDIR}/${PN}"

LICENSE="CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
IUSE=""

RDEPEND=""
DEPEND="${RDEPEND}"

src_install() {
	insinto "${GAMES_DATADIR}/minetest/games/main"
	doins "${S}/game.conf"
	doins -r "${S}/mods"

	prepgamesdirs
}
