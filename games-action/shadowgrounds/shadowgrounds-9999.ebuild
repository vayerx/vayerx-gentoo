# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit cmake git-r3

EGIT_REPO_URI="git://github.com/vayerx/shadowgrounds.git"
EGIT_BRANCH="linux"

if [[ "${PV}" = 9999* ]]; then
	KEYWORDS=""
else
	EGIT_COMMIT="amd64-${PV}"
	KEYWORDS="~amd64"
fi

DESCRIPTION="Shadowgrounds is 3rd-person alien-shooter."
HOMEPAGE="https://github.com/vayerx/shadowgrounds"
SRC_URI=""

LICENSE="shadowgrounds"
SLOT="0"
IUSE=""

RDEPEND="
	dev-libs/boost:=
	media-libs/glew:=
	media-libs/libsdl[sound,video,joystick,X,opengl]
	media-libs/sdl-sound
	media-libs/sdl-image
	media-libs/sdl-ttf
	virtual/opengl
	x11-libs/gtk+:=
	sys-libs/zlib
	media-libs/openal
"
DEPEND="${RDEPEND}
	virtual/pkgconfig
"

src_configure() {
	mycmakeargs+=(
		"-DICON_DIR=/usr/share/pixmaps"
		"-DDESKTOP_DIR=/usr/share/applications"
		"-DCMAKE_DATA_PATH=/usr/share/${PN}"
		"-DCMAKE_CONF_PATH=/etc/${PN}"
		"-DINSTALLONLY=${PN}"
	)

	cmake_src_configure
}

src_compile() {
	cmake_src_compile shadowgrounds
}

pkg_postinst() {
	ewarn "You will need data files to run the game."
	ewarn "Consider installing games-action/shadowgrounds-data"
	ewarn "or copying files manually to /usr/share/${PN}"
}
