# Copyright 1999-2023 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 python3_{9,10,11} )

inherit distutils-r1

DESCRIPTION="Object-oriented layer over Psycopg2 to interact with Postgres databases"
HOMEPAGE="https://github.com/perseas/pgdbconn"

if [[ "${PV}" = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="git://github.com/perseas/${PN}.git"
	KEYWORDS=""
else
	SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
	KEYWORDS="~amd64 ~x86"
fi

LICENSE="BSD"
SLOT="0"
IUSE=""

DEPEND="dev-python/setuptools"

RDEPEND="${DEPEND}
	>=dev-python/psycopg-2.5
"