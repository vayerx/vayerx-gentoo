# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils games cmake-utils git-2

DESCRIPTION="An InfiniMiner/Minecraft inspired game."
HOMEPAGE="http://celeron.55.lt/~celeron55/minetest/"

EGIT_REPO_URI="git://github.com/celeron55/minetest.git"
EGIT_COMMIT="9696ed31a41b5e3ca85bad4a29c190a0d25c7752"

KEYWORDS="~x86 ~amd64"

SRC_URI=""
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE="+client nls +server"

RDEPEND="
	app-arch/bzip2
	dev-db/sqlite:3
	>=dev-games/irrlicht-1.7
	>=dev-libs/jthread-1.2
	media-libs/glu
	media-libs/libpng
	nls? ( sys-devel/gettext )
	sys-libs/zlib
	virtual/opengl
	x11-libs/libX11
"
DEPEND="${RDEPEND}"

src_configure() {
	mycmakeargs="
		-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}
		-DRUN_IN_PLACE=0
		-DJTHREAD_INCLUDE_DIR="${EROOT}/usr/include/jthread"
		$(cmake-utils_use_build client CLIENT)
		$(cmake-utils_use_build server SERVER)
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
