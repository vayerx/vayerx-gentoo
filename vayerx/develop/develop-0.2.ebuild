# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Development meta package"
HOMEPAGE="https://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+cpp java ruby +python database postgres sqlite exotic +kde math +network +rich +testing"

PDEPEND="
	kde? (
		kde-apps/kompare
		kde-apps/umbrello
		kde-misc/kdiff3
	)

	cpp? (
		dev-cpp/cppstaff
		sys-devel/gcc[cxx]
	)

	java? (
		dev-java/javacc
		dev-util/idea-community
	)

	ruby? (
		dev-lang/ruby
		dev-ruby/rbstaff[database?]
	)

	python? (
		dev-lang/python
		dev-python/pystaff
		dev-util/pycharm-community
	)

	database? (
		postgres? (
			dev-db/pgadmin4
			dev-db/postgresql[server]
		)

		sqlite? (
			dev-db/sqlite
			dev-db/sqliteman
		)
	)

	math? (
		sci-mathematics/octave
	)
"
