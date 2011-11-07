# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

PYTHON_DEPEND="*"
SUPPORT_PYTHON_ABIS="1"
RESTRICT_PYTHON_ABIS="2.4 2.5 3.* *-jython"
inherit distutils python

DESCRIPTION="Openbox Key Editor, written in Python + PyGTK"
HOMEPAGE="http://code.google.com/p/obkey/"
SRC_URI="http://${PN}.googlecode.com/files/${P}.tar.gz"

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
