# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit autotools games git-2

EGIT_REPO_URI="https://github.com/vayerx/alienarena.git"
EGIT_BRANCH="devel"
EGIT_HAS_SUBMODULES="yes"

if [[ "${PV}" = 9999* ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT="amd64_${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Fast-paced multiplayer deathmatch game"
HOMEPAGE="http://red.planetarena.org/"
SRC_URI=""

LICENSE="GPL-2 free-noncomm"
SLOT="0"
IUSE="dedicated +dga +vidmode rockethell"

UIRDEPEND="virtual/jpeg
	media-libs/openal
	media-libs/libvorbis
	media-libs/freetype:2
	virtual/glu
	virtual/opengl
	dga? ( x11-libs/libXxf86dga )
	vidmode? ( x11-libs/libXxf86vm )
	net-misc/curl"
UIDEPEND="dga? ( x11-proto/xf86dgaproto )
	vidmode? ( x11-proto/xf86vidmodeproto )
"

RDEPEND="!dedicated? ( ${UIRDEPEND} )
	!games-fps/alienarena
"

DEPEND="${RDEPEND}
	!dedicated? ( ${UIDEPEND} )
	virtual/pkgconfig
"

src_prepare() {
	epatch "${FILESDIR}"/${P}-nodocs.patch
	if use rockethell; then
		epatch "${FILESDIR}"/rocket_hell-${PV}.patch
	fi
	eautoreconf
}

src_configure() {
	egamesconf \
		--disable-silent-rules \
		--disable-dependency-tracking \
		--with-icondir=/usr/share/pixmaps \
		--without-system-libode \
		$(use_enable !dedicated client) \
		$(use_with dga xf86dga) \
		$(use_with vidmode xf86vm)
}

src_install() {
	emake DESTDIR="${D}" install || die
	if ! use dedicated ; then
		make_desktop_entry alienarena "Alien Arena" alienarena
	fi
	dodoc docs/README.txt README
	prepgamesdirs
}
