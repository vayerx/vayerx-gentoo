# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit distutils

DESCRIPTION="XPath-like tool for JSON"
HOMEPAGE="http://www.ultimate.com/phil/python/#jsonpath"
SRC_URI="http://www.ultimate.com/phil/python/download/${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools"
RDEPEND=""

src_unpack() {
	# 0.54 is named '.tar.gz' but is a non-gziped tarball.
	tar -xf "${DISTDIR}/${A}" -C "${WORKDIR}"
}
