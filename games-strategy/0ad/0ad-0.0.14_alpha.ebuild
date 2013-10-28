# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit eutils wxwidgets games versionator

MY_P="$PN-$(replace_version_separator 3 '-')"
S="${WORKDIR}/${MY_P}"

DESCRIPTION="0 A.D. is a free, real-time strategy game currently under development by Wildfire Games."
HOMEPAGE="http://play0ad.com"
SRC_URI="mirror://sourceforge/zero-ad/${MY_P}-unix-build.tar.xz"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+audio editor fam nvtt pch test"

RDEPEND="~games-strategy/0ad-data-${PV}
	>=dev-lang/spidermonkey-1.8.5
	dev-libs/boost
	dev-libs/libxml2
	media-libs/devil
	audio? ( media-libs/libogg
		media-libs/libvorbis
		media-libs/openal )
	media-libs/libpng
	media-libs/libsdl[X,audio?,opengl,video]
	net-libs/enet:1.3
	net-misc/curl
	sys-libs/zlib
	fam? ( virtual/fam )
	virtual/jpeg
	virtual/opengl
	editor? ( x11-libs/wxGTK:2.8[X] )
	nvtt? ( dev-util/nvidia-texture-tools )"

DEPEND="${RDEPEND}
	virtual/pkgconfig
	test? ( dev-lang/perl )"

RESTRICT="strip mirror"

dir=${GAMES_PREFIX_OPT}/${PN}

pkg_setup() {
	games_pkg_setup
	if use editor ; then
		WX_GTK_VER=2.8 need-wxwidgets unicode
	fi
}

src_configure() {
	cd build/workspaces || die

	# custom configure script
	local myconf
	use nvtt || myconf="--without-nvtt"
	use fam || myconf="${myconf} --without-fam"
	use pch || myconf="${myconf} --without-pch"
	use test || myconf="${myconf} --without-tests"
	use audio || myconf="${myconf} --without-audio"

	# don't use bundled sources
	./update-workspaces.sh \
		--with-system-nvtt \
		--with-system-enet \
		--with-system-mozjs185 \
		$(use_enable editor atlas) \
		--bindir="${GAMES_BINDIR}" \
		--libdir="$(games_get_libdir)"/${PN} \
		--datadir="${GAMES_DATADIR}"/${PN} \
		${myconf} || die
}

src_compile() {
	cd build/workspaces/gcc || die

	emake CONFIG=Release verbose=1 || die
}

src_test() {
	cd binaries/system || die

	if use nvtt ; then
		./test || die "Test failed"
	else
		ewarn "Skipping tests because USE nvtt is disabled"
	fi
}

src_install() {
	# bin
	dogamesbin binaries/system/pyrogenesis || die

	# libs
	exeinto "$(games_get_libdir)"/${PN}
	doexe binaries/system/libCollada.so || die
	if use editor ; then
		doexe binaries/system/libAtlasUI.so || die
	fi

	# other
	dodoc binaries/system/readme.txt || die
	doicon build/resources/${PN}.png || die
	games_make_wrapper ${PN} "${GAMES_BINDIR}/pyrogenesis"
	make_desktop_entry ${PN} ${PN} ${PN}

	# permissions
	prepgamesdirs
}
