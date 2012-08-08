# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Development meta package"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="+cpp ruby +python database postgres sqlite exotic +kde math +network +rich +testing"

PDEPEND="
	app-doc/doxygen
	app-editors/hexedit
	app-i18n/enca
	dev-libs/libxml2
	dev-util/geany
	dev-util/meld
	dev-util/strace
	dev-util/uncrustify
	dev-vcs/gitflow
	dev-vcs/gitg
	dev-vcs/git[tk]
	sci-calculators/galculator
	sci-visualization/gnuplot

	kde? (
		kde-base/kompare
		kde-base/umbrello
		kde-misc/kdiff3
	)

	cpp? (
		dev-cpp/cppstaff[rich?,exotic?,testing?]
		sys-devel/gcc[cxx]
	)

	ruby? (
		dev-lang/ruby
		dev-ruby/staff-rb[database?,exotic?,testing?]
	)

	python? (
		dev-lang/python
		dev-python/pystaff[database?,exotic?,testing?]
		dev-python/spyder[pylint,sphinx]
	)

	database? (
		postgres? (
			dev-db/pgadmin3
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

	rich? (
		dev-util/argouml
		dev-util/mutrace
	)
"
