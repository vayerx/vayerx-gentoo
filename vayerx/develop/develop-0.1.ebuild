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
IUSE="+cpp java ruby +python database postgres sqlite exotic +kde math +network +rich +testing"

PDEPEND="
	dev-util/meld

	kde? (
		kde-base/kdebase-runtime-meta
		kde-base/kompare
		kde-base/umbrello
		kde-misc/kdiff3
	)

	cpp? (
		dev-cpp/cppstaff[rich?,exotic?,testing?,kde?]
		sys-devel/gcc[cxx]
	)

	java? (
		dev-java/javacc
		dev-util/idea-community
	)

	ruby? (
		dev-lang/ruby
		dev-ruby/staff-rb[database?,exotic?,testing?]
	)

	python? (
		dev-lang/python
		dev-python/pystaff[database?,rich?,testing?]
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
