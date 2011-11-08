# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils games cmake-utils git-2

DESCRIPTION="An InfiniMiner/Minecraft inspired game."
HOMEPAGE="http://celeron.55.lt/~celeron55/minetest/"

EGIT_REPO_URI="git://github.com/celeron55/minetest.git"
EGIT_COMMIT="045e32b"
KEYWORDS="~x86 ~amd64"

SRC_URI=""
S="${WORKDIR}/${PN}"

LICENSE="GPL-2"
SLOT="0"
IUSE="+client nls +server"

RDEPEND="
	sys-libs/zlib
	nls? ( sys-devel/gettext )
	>=dev-games/irrlicht-1.7
	x11-libs/libX11
	virtual/opengl
	app-arch/bzip2
	media-libs/libpng
	dev-db/sqlite:3
	>=dev-libs/jthread-1.2
"
DEPEND="${RDEPEND}"

src_configure() {
	# we redesignate installation paths to the games prefix and 
	# intentionally break project supplied jthread and sqlite source
	sed -i -e "s|set(BINDIR \"bin|set(BINDIR \"games/bin|g" \
		-e "s|set(DATADIR \"share/|set(DATADIR \"share/games/|g" \
		-e "/^if (SQLITE/,/^endif (SQLITE/d" \
		-e "/^if (JTHREAD/,/^endif (JTHREAD/d" \
		CMakeLists.txt || die "games prefix paths not reset"

	# we also need to redesignate the language file location since
	# it shouldn't live in /usr/share/games/locale..
	sed -i -e \
	"s|GETTEXT_MO_DEST_PATH \${DATADIR}/|GETTEXT_MO_DEST_PATH \${DATADIR}/../|g" \
		cmake/Modules/FindGettextLib.cmake || die "locale path not reset"

	mycmakeargs="
		-DRUN_IN_PLACE=0
		-DJTHREAD_INCLUDE_DIR=${EROOT}/usr/include/jthread
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
