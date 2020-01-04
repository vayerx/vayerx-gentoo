# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Openbox Key Editor, written in Python + PyGTK"
HOMEPAGE="https://github.com/nsf/${PN}"
SRC_URI="https://github.com/nsf/${PN}/archive/v${PV}.tar.gz -> ${PN}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND=""
RDEPEND="${DEPEND}
	dev-python/pygtk"

src_install() {
	distutils-r1_src_install

	insinto /usr/share/applications
	doins misc/${PN}.desktop || die
}
