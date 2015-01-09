# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit eutils games versionator

MY_PV=$(get_version_component_range 1-2)

DESCRIPTION="Everlasting Summer is a visual novel about the days past."
HOMEPAGE="http://everlastingsummer.su/"

SRC_URI="everlasting_summer-${MY_PV}-all.zip"
RESTRICT="fetch"

LICENSE="CC-BY-NC-SA-4.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"

IUSE="+system-renpy"

RDEPEND="
	system-renpy? ( games-engines/renpy:6.18[char_args_patch] )
	media-libs/freetype
	media-libs/glew
	media-libs/libjpeg-turbo
	media-libs/libpng:1.2
	media-libs/libsdl
	media-libs/sdl-image
	media-libs/sdl-sound
	media-libs/sdl-ttf
	media-video/ffmpeg
	sys-libs/zlib
"
DEPEND="app-arch/unzip"

QA_PREBUILT="${GAMES_PREFIX_OPT}/${PN}/lib/*"

S="${WORKDIR}/everlasting_summer-${MY_PV}-all"

src_unpack() {
	unzip "${DISTDIR}/${A}" "everlasting_summer-${MY_PV}-all/game/*" $(usex system-renpy "" "everlasting_summer-${MY_PV}-all/renpy/*")
}

src_install() {
	if use system-renpy ; then
		insinto "${GAMES_DATADIR}/${PN}"
		doins -r game/.
		games_make_wrapper ${PN} "renpy --savedir \${HOME}/.everlasting_summer-${MY_PV} '${GAMES_DATADIR}/${PN}'"
	else
		insinto "${GAMES_PREFIX_OPT}"/${PN}
		doins -r game renpy "Everlasting Summer.py"
		games_make_wrapper ${PN} "${GAMES_PREFIX_OPT}/${PN}/Everlasting Summer.py" "${GAMES_PREFIX_OPT}/${PN}/game"
		fperms +x "${GAMES_PREFIX_OPT}/${PN}/Everlasting Summer.sh"
	fi

	newicon "${FILESDIR}"/es.png ${PN}.png
	make_desktop_entry ${PN} "Everlasting Summer"

	prepgamesdirs
}

pkg_postinst() {
	elog "Savegames from system-renpy and the bundled version are incompatible"

	if use system-renpy; then
		ewarn "system-renpy is unstable and not supported upstream"
	fi

	games_pkg_postinst
}
