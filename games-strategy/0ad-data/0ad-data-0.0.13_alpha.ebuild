# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit games versionator

MY_PN="${PN%-data}"
MY_P="$MY_PN-$(replace_version_separator 3 '-')"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="Data files for 0ad"
HOMEPAGE="http://play0ad.com"
SRC_URI="mirror://sourceforge/zero-ad/${MY_P}-unix-data.tar.xz"

LICENSE="GPL-2 CC-BY-SA-3.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

src_install() {
	insinto "${GAMES_DATADIR}"/${MY_PN}
	doins -r binaries/data/* || die
	prepgamesdirs
}
