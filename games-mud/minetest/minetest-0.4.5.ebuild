# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
inherit eutils games cmake-utils git-2

DESCRIPTION="An infinite-world block sandbox game and a game engine, inspired by InfiniMiner, Minecraft and the like."
HOMEPAGE="http://minetest.net"

EGIT_REPO_URI="git://github.com/minetest/minetest.git"

if [[ "${PV}" = 9999* ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT="${PV}"
	KEYWORDS="~x86 ~amd64"
fi

SRC_URI=""
S="${WORKDIR}/${PN}"

LICENSE="LGPL-2.1+ CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
IUSE="dedicated nls +server +sound"

RDEPEND="
	dev-db/sqlite:3
	dev-lang/lua
	=dev-libs/jthread-1.2.1*
	>=dev-libs/jsoncpp-0.6.0_rc2
	sys-libs/zlib
	!dedicated? (
		app-arch/bzip2
		media-libs/libogg
		media-libs/libpng:0
		media-libs/libvorbis
		sound? ( media-libs/openal )
		virtual/glu
		virtual/jpeg
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXxf86vm
	)
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
	>=dev-games/irrlicht-1.7
	nls? ( sys-devel/gettext )
"

src_prepare() {
	epatch \
		"${FILESDIR}"/${P}-syslibs.patch \
		"${FILESDIR}"/${P}-event.patch

	# these should not be used during building anyway so we delete them
	rm -r src/{jthread,lua,sqlite,json} || die
}

src_configure() {
	local mycmakeargs=(
		-DRUN_IN_PLACE=0
		-DCUSTOM_SHAREDIR="${GAMES_DATADIR}/${PN}"
		-DCUSTOM_BINDIR="${GAMES_BINDIR}"
		-DCUSTOM_DOCDIR="/usr/share/doc/${PF}"
		-DJTHREAD_INCLUDE_DIR="${EROOT}/usr/include/jthread"
		$(usex dedicated "-DBUILD_SERVER=ON -DBUILD_CLIENT=OFF" "$(cmake-utils_use_build server SERVER) -DBUILD_CLIENT=ON")
		$(cmake-utils_use_enable sound SOUND)
		$(cmake-utils_use_use nls GETTEXT)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install
	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst
	enewgroup minetest
	enewuser minetest -1 -1 /var/lib/minetest "minetest,games"
	doinitd "${FILESDIR}/minetestserver.init"
}

pkg_postinst() {
	games_pkg_postinst

	if ! use dedicated ; then
		elog "optional dependencies:"
		elog "	games-mud/minetest-game (official main mod)"
	fi
}