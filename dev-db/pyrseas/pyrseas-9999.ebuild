# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{6,7,8} )

inherit distutils-r1

DESCRIPTION="Framework and utilities to upgrade and maintain databases"
HOMEPAGE="http://pyrseas.readthedocs.org"

if [[ "${PV}" = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/perseas/Pyrseas.git"
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="
	dev-python/setuptools
	dev-python/pgdbconn"

RDEPEND="${DEPEND}
	dev-db/postgresql
	dev-python/pyyaml
"
