# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

[[ ${PV} = 9999* ]] && GIT="git-2"
EGIT_REPO_URI="git://github.com/vayerx/shadowgrounds.git"
EGIT_BRANCH="linux"

inherit games cmake-utils ${GIT}

DESCRIPTION="Shadowgrounds is 3rd-person alien-shooter."
HOMEPAGE="http://github.com/vayerx/shadowgrounds"
SRC_URI=""

LICENSE="shadowgrounds"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	>=dev-libs/boost-1.37
	media-libs/libsdl[audio,video,joystick,X,opengl]
	media-libs/sdl-sound
	media-libs/sdl-image
	media-libs/sdl-ttf
	virtual/opengl
	x11-libs/gtk+
	sys-libs/zlib
	media-libs/openal
	games-action/shadowgrounds-data
"
DEPEND="${RDEPEND}
	dev-util/pkgconfig
"

src_configure() {
	mycmakeargs+=(
		"-DCMAKE_INSTALL_PREFIX=${GAMES_PREFIX}"
		"-DCMAKE_DATA_PATH=${GAMES_DATADIR}"
		"-DCMAKE_CONF_PATH=${GAMES_SYSCONFDIR}"
	)

	cmake-utils_src_configure
}

src_compile() {
	cmake-utils_src_make shadowgrounds
}

src_install() {
	cmake-utils_src_install

	doicon Shadowgrounds.xpm || die
	make_desktop_entry shadowgrounds "Shadowgrounds"

	prepgamesdirs
}
