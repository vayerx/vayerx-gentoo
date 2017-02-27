# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

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
		kde-apps/kdebase-runtime-meta
		kde-apps/kompare
		kde-apps/umbrello
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
		dev-ruby/rbstaff[database?]
	)

	python? (
		dev-lang/python
		dev-python/pystaff[database?,rich?,testing?]
		dev-python/spyder[pylint]

		rich? (
			dev-util/ninja-ide
		)
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
"
