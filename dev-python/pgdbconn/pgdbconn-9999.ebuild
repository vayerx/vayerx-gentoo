# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=5

PYTHON_COMPAT=( python2_7 python3_{3,4,5,6} )

inherit distutils-r1

DESCRIPTION="Object-oriented layer over Psycopg2 to connect and interact with Postgres databases"
HOMEPAGE="https://github.com/perseas/pgdbconn"

if [[ "${PV}" = 9999* ]]; then
	inherit git-2
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