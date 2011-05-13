# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit games eutils

DESCRIPTION="A physics-based action game where diff characters allow diff solutions to challenges"
HOMEPAGE="http://trine-thegame.com/"
SRC_URI="TrineUpdate3.64.run"

LICENSE="frozenbyte-eula"
SLOT="0"
KEYWORDS="-* ~amd64"
IUSE=""
RESTRICT="fetch strip"

DEPEND="app-arch/unzip"
RDEPEND=">=sys-libs/glibc-2.4
	>=sys-devel/gcc-4.3.0
	gnome-base/libglade
	=media-libs/glew-1.5*
	=media-libs/libsdl-1.2*
	=media-libs/sdl-image-1.2*
	=media-libs/sdl-ttf-2.0*
	virtual/ffmpeg
	media-libs/jpeg:62
	media-libs/libogg
	=media-libs/openal-1*
	media-libs/libpng:1.2
	media-libs/libvorbis
	dev-libs/boost:0
	amd64? ( dev-libs/libx86 )"

S=${WORKDIR}

d="${GAMES_PREFIX_OPT}/${PN}"
QA_PRESTRIPPED="${d#/}/trine-launcher ${d#/}/trine-bin ${d#/}/lib*/lib*.so*"
QA_TEXTRELS_x86="`echo ${d#/}/lib32/lib{avcodec.so.51,avformat.so.52,avutil.so.49,FLAC.so.8}`"

bits=$(use x86 && echo 32 || echo 64)

pkg_nofetch() {
	einfo "Fetch ${SRC_URI} and put it into ${DISTDIR}"
	einfo "See http://www.humblebundle.com/ for more info."
}

src_unpack() {
	# manually run unzip as the initial seek causes it to exit(1)
	unzip -q "${DISTDIR}/${A}"
	rm lib*/lib{gcc_s,m,rt,selinux}.so.?

	# remove bundled libraries
	rm "${S}/lib${bits}/libGLEW.so.1.5"
	rm "${S}/lib${bits}/libstdc++.so.6"
	rm "${S}/lib${bits}/libSDL-1.2.so.0"
	rm "${S}/lib${bits}/libSDL_image-1.2.so.0"
	rm "${S}/lib${bits}/libSDL_ttf-2.0.so.0"
	rm "${S}/lib${bits}/libavcodec.so.52"
	rm "${S}/lib${bits}/libavformat.so.52"
	rm "${S}/lib${bits}/libavutil.so.50"
	rm "${S}/lib${bits}/libjpeg.so.62"
	rm "${S}/lib${bits}/libogg.so.0"
	rm "${S}/lib${bits}/libopenal.so.1"
	rm "${S}/lib${bits}/libpng12.so.0"
	rm "${S}/lib${bits}/libswscale.so.0"
	rm "${S}/lib${bits}/libvorbis.so.0"
	rm "${S}/lib${bits}/libvorbisfile.so.3"
	rm "${S}/lib${bits}/libboost_filesystem.so.1.35.0"
	rm "${S}/lib${bits}/libboost_regex.so.1.35.0"
	rm "${S}/lib${bits}/libboost_system.so.1.35.0"
	rm "${S}/lib${bits}/libboost_thread-mt.so.1.35.0"
}

src_install() {
	local b bb

	# the game binary expects different library file naming for boost
	for boost_lib in filesystem regex system thread-mt ; do
	dosym "/usr/$(get_libdir)/libboost_${boost_lib}-1_35.so.1.35.0" "${d}/lib${bits}/libboost_${boost_lib}.so.1.35.0" || die
	done

	doicon Trine.xpm || die
	for b in bin launcher ; do
	bb="trine-${b}"
	exeinto ${d}
	newexe ${bb}${bits} ${bb} || die
	games_make_wrapper ${bb} "./${bb}" "${d}" || die
	make_desktop_entry ${bb} "Trine ${b}" Trine
	done

	exeinto ${d}/lib${bits}
	doexe lib${bits}/* || die

	insinto ${d}
	doins -r binds config data dev profiles *.fbz *.glade trine-logo.png || die

	dodoc Trine_Manual_linux.pdf Trine_updates.txt

	prepgamesdirs
}
