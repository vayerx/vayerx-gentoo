# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Miscellaneous C++ staff, vayerx edition"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="database exotic +rich +testing +kde"

PDEPEND="
	dev-libs/boost[doc,tools]
	dev-util/ccache
	dev-util/cmake
	dev-util/valgrind

	kde? (
		dev-util/kdevelop[cxx]
		kde-base/kcachegrind
		kde-base/kdebase-runtime-meta
	)
	!kde? (
		dev-util/qt-creator[cmake,git,valgrind]
	)

	testing? (
		dev-cpp/gmock
		dev-util/cppcheck
		dev-util/cppunit
		dev-util/flawfinder
		dev-util/lcov
	)

	rich? (
		dev-cpp/tbb
		dev-libs/oniguruma
		dev-util/qt-creator[cmake,git,valgrind]
		dev-util/re2c
	)
"
