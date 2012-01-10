# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="3"

inherit eutils wxwidgets subversion games flag-o-matic

ESVN_REPO_URI="http://svn.wildfiregames.com/public/ps/trunk"

DESCRIPTION="0 A.D. is a free, real-time strategy game currently under development by Wildfire Games."
HOMEPAGE="http://wildfiregames.com/0ad/"

LICENSE="GPL-2 CCPL-Attribution-ShareAlike-3.0"
SLOT="0"
KEYWORDS=""
IUSE="debug editor nvtt pch test"

RDEPEND=">=dev-lang/spidermonkey-1.8[threadsafe]
	dev-libs/boost
	dev-libs/crypto++
	dev-libs/libxml2
	dev-libs/xerces-c
	nvtt? ( dev-util/nvidia-texture-tools )
	dev-util/valgrind
	editor? ( x11-libs/wxGTK:2.8 )
	media-libs/devil
	media-libs/libogg
	media-libs/libpng
	media-libs/libsdl[joystick]
	media-libs/libvorbis
	net-libs/enet:1.3
	net-misc/curl
	media-libs/openal
	media-video/ffmpeg
	net-libs/enet
	sys-libs/zlib
	virtual/fam
	virtual/jpeg
	virtual/opengl
"

DEPEND="${RDEPEND}
	app-arch/zip
	dev-lang/nasm
	dev-util/cmake"

RESTRICT="strip"

dir=${GAMES_PREFIX_OPT}/${PN}
Ddir="${D}/${dir}"

pkg_setup() {
	append-ldflags -Wl,--no-as-needed
	games_pkg_setup
	if use editor ; then
		WX_GTK_VER=2.8 need-wxwidgets unicode
	fi
}

src_unpack() {
	subversion_src_unpack
	rm -rf "${S}"/binaries/system/*
}

src_compile() {
	UPDATE_ARGS="--with-system-enet --with-system-mozjs185"

	#if ! use editor; then
	#	sed -i "s:--atlas::" "${S}/build/workspaces/update-workspaces.sh" \
	#	|| die "AtlasUI sed failed"
	#fi

	if ! use editor ; then
		UPDATE_ARGS="${UPDATE_ARGS} --disable-atlas"
	fi

	if use nvtt ; then
		UPDATE_ARGS="${UPDATE_ARGS} --with-system-nvtt"
	fi

	cd "${S}/libraries/fcollada/src"
	emake || die "Can't build fcollada"
	cd "${S}/build/workspaces"
	einfo "Running update-workspaces.sh with ${UPDATE_ARGS}"
	./update-workspaces.sh ${UPDATE_ARGS} || die "update-workspaces.sh failed"
	cd gcc

	TARGETS="pyrogenesis Collada"
	if use test ; then
		TARGETS="${TARGETS} test"
	fi
	if use editor ; then
		TARGETS="${TARGETS} AtlasUI"
	fi
	if use debug ; then
		CONFIG=Debug
	else
		CONFIG=Release
	fi
	CONFIG=${CONFIG} emake ${TARGETS} || die "Can't build"
}

src_test() {
	cd "${S}/binaries/system"
	if use debug ; then
		./test_dbg || die "Tests failed"
	else
		./test || die "Tests failed"
	fi
}

src_install() {
	cd "${S}"/binaries/
	insinto "${dir}"
	doins -r data logs || die "doins -r failed"

	exeinto "${dir}"/system
	doexe "${S}"/binaries/system/{pyrogenesis_dbg,test_dbg} || die "doexe failed"

	insinto "${dir}"/system
	doins "${S}"/binaries/system/{*.a,*.so} || die	"doins failed"

	#we install build-in nvtt
	if use !nvtt ; then
		doins "${S}"/binaries/system/libnvcore.so || die "doins failed"
		doins "${S}"/binaries/system/libnvimage.so || die "doins failed"
		doins "${S}"/binaries/system/libnvmath.so || die "doins failed"
		doins "${S}"/binaries/system/libnvtt.so || die "doins failed"
	fi

	if use debug ; then
#		doins "${S}"/binaries/system/libmozjs185-ps-debug.so.1.0 || die "doins failed"
		doins "${S}"/binaries/system/libCollada_dbg.so || die "doins failed"
		if use editor ; then
			doins "${S}"/binaries/system/libAtlasUI_dbg.so || die "doins failed"
		fi
		EXE_NAME=pyrogenesis_dbg
	else
#		doins "${S}"/binaries/system/libmozjs185-ps-release.so.1.0 || die "doins failed"
		doins "${S}"/binaries/system/libCollada.so || die "doins failed"
		if use editor ; then
			doins "${S}"/binaries/system/libAtlasUI.so || die "doins failed"
		fi
		EXE_NAME=pyrogenesis
	fi

	exeinto "${dir}"/system
	doexe "${S}"/binaries/system/${EXE_NAME} || die "doexe failed"

	games_make_wrapper ${PN} ./system/${EXE_NAME} ${dir}
	doicon "${S}"/build/resources/0ad.png
	make_desktop_entry "${dir}"/system/${EXE_NAME} "0 A.D."

	prepgamesdirs
	chmod g+rw "${Ddir}/logs" "${Ddir}/data/cache"
}
