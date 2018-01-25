# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

DESCRIPTION="Miscellaneous C++ staff, vayerx edition"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="database exotic +rich +testing +kde"

PDEPEND="
	dev-libs/boost
	dev-util/ccache

	kde? (
		dev-util/kdevelop
		kde-apps/konsole
		kde-apps/kcachegrind
	)
	!kde? (
		dev-qt/qt-creator[cmake,git,valgrind]
	)

	testing? (
		dev-cpp/gtest
		dev-util/cppcheck
		dev-util/cppunit
		dev-util/flawfinder
		dev-util/lcov
	)

	rich? (
		dev-cpp/tbb
		dev-libs/oniguruma
		dev-qt/qt-creator[cmake,git,valgrind]
	)
"
