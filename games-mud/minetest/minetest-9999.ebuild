# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils games cmake-utils git-2

DESCRIPTION="An InfiniMiner/Minecraft inspired game."
HOMEPAGE="http://celeron.55.lt/~celeron55/minetest/"

EGIT_REPO_URI="git://github.com/celeron55/minetest.git"

if [[ "${PV}" = 9999* ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT="${PV}"
	KEYWORDS="~x86 ~amd64"
fi

SRC_URI=""
S="${WORKDIR}/${PN}"

LICENSE="LGPL-2.1+"
SLOT="0"
IUSE="+client +game nls +server +sound"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	>=dev-games/irrlicht-1.7
	>=dev-libs/jthread-1.2
	media-libs/libpng
	nls? ( sys-devel/gettext )
	sound? ( media-libs/openal )
	sys-libs/zlib
	virtual/glu
	virtual/opengl
	x11-libs/libX11
	game? ( games-mud/minetest-data )
"
DEPEND="${RDEPEND}"

src_configure() {
	mycmakeargs="
		-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
		-DRUN_IN_PLACE=0
		-DJTHREAD_INCLUDE_DIR="${EROOT}/usr/include/jthread"
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build server SERVER)
		$(cmake-utils_use_enable sound SOUND)
		$(cmake-utils_use_use nls GETTEXT)"

	cmake-utils_src_configure
}

src_prepare() {
	# these should not be used during building anyway so we delete them
	rm -rf src/{jthread,sqlite}
}

pkg_preinst() {
	enewgroup minetest
	enewuser minetest -1 -1 /var/lib/minetest "minetest,games"
	mkdir -p "${D}/var/lib/minetest"
	mkdir -p "${D}/etc/init.d"
	chown minetest:minetest "${D}/var/lib/minetest"
	cp "${FILESDIR}"/minetestserver.init "${D}/etc/init.d/minetestserver"
}
