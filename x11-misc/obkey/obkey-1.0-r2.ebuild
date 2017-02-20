# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit distutils-r1

DESCRIPTION="Openbox Key Editor, written in Python + PyGTK"
HOMEPAGE="https://github.com/nsf/${PN}"
SRC_URI="mirror://github/nsf/${PN}/${P}.tar.gz"
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
