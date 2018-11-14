# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Development meta package"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="+cpp java ruby +python database postgres sqlite exotic +kde math +network +rich +testing qt4"

PDEPEND="
	dev-util/meld

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
		dev-python/spyder

		qt4? (
			dev-util/ninja-ide
		)
	)

	database? (
		postgres? (
			dev-db/pgadmin4
			dev-db/postgresql-server
		)

		sqlite? (
			dev-db/sqlite
			dev-db/sqliteman
		)
	)

	math? (
		sci-mathematics/qtoctave
	)
"
