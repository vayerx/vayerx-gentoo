# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python3_{4,5,6} pypy )

inherit distutils-r1

DESCRIPTION="Public Suffix List parser implementation."
HOMEPAGE="https://github.com/ko-zu/psl"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="MPL-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+update"

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND="
	update? (
	    dev-python/requests
	)
"
