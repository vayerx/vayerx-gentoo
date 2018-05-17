# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )

inherit distutils-r1 flag-o-matic

DESCRIPTION="Simple MSSQL python extension module"
HOMEPAGE="https://github.com/pymssql/pymssql http://pypi.python.org/pypi/pymssql"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
RESTRICT="primaryuri"

LICENSE="LGPL-2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-db/freetds[mssql]
	dev-python/setuptools[${PYTHON_USEDEP}]"

RDEPEND="${DEPEND}"

src_prepare() {
	epatch "${FILESDIR}/${PV}-dbversion_80.patch"
	rm "${S}/_mssql.c" || die "can't delete _mssql.c"
	eapply_user
}

python_configure_all() {
	append-flags -fno-strict-aliasing
}
