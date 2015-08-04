# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

PYTHON_COMPAT=( python2_7 python3_3 )

inherit distutils-r1

DESCRIPTION="Database schema migration tool using SQL and DB-API"
HOMEPAGE="https://pypi.python.org/pypi/yoyo-migrations"

SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"
KEYWORDS="~amd64 ~x86"

LICENSE="BSD"
SLOT="0"
IUSE="mysql odbc postgres"

DEPEND="dev-python/setuptools"

RDEPEND="${DEPEND}
	odbc? ( dev-python/pyodbc )
	postgres? ( dev-python/psycopg:2 )
"
# TODO dev-python/mysql-python
