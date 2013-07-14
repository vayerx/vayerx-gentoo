# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils games cmake-utils git-2 user

DESCRIPTION="An infinite-world block sandbox game and a game engine, inspired by InfiniMiner, Minecraft, etc."
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

LICENSE="LGPL-2.1+ CC-BY-SA-3.0"
SLOT="0"
IUSE="+curl dedicated nls +server +sound +truetype"

RDEPEND="
	curl? ( net-misc/curl )
	!dedicated? (
		sound? (
			media-libs/libogg
			media-libs/libvorbis
			media-libs/openal
		)
		app-arch/bzip2
		media-libs/libpng:0
		virtual/glu
		virtual/jpeg
		virtual/opengl
		x11-libs/libX11
		x11-libs/libXxf86vm
		truetype? ( media-libs/freetype:2 )
	)
	dev-db/sqlite:3
	>=dev-games/irrlicht-1.8
	>=dev-lang/lua-5.1.4
	>=dev-lang/luajit-1.1.6
	>=dev-libs/jsoncpp-0.6.0_rc2
	=dev-libs/jthread-1.2.1*
	sys-libs/zlib
	nls? ( virtual/libintl )
"
DEPEND="${RDEPEND}
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
		$(cmake-utils_use_enable nls GETTEXT)
		$(cmake-utils_use_enable curl CURL)
		$(cmake-utils_use_enable truetype FREETYPE)
		$(cmake-utils_use_enable sound SOUND)
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_compile
}

src_install() {
	cmake-utils_src_install

	if use server || use dedicated ; then
		newinitd "${FILESDIR}"/minetestserver.init minetest-server
		newconfd "${FILESDIR}"/minetestserver.conf minetest-server
	fi

	prepgamesdirs
}

pkg_preinst() {
	games_pkg_preinst

	if use server || use dedicated ; then
		enewgroup ${PN}
		enewuser ${PN} -1 -1 /var/lib/${PN} "${PN},${GAMES_GROUP}"
	fi
}

pkg_postinst() {
	games_pkg_postinst

	if ! use dedicated ; then
		elog "optional dependencies:"
		elog "	games-mud/minetest-data (official main mod)"
	fi
}
