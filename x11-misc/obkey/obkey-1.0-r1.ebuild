# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.* *-jython"
inherit distutils python

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
	distutils_src_install
	insinto /usr/share/applications
	doins misc/${PN}.desktop || die
}
