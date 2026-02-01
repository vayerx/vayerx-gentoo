# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Miscellaneous C++ staff, vayerx edition"
HOMEPAGE="https://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE="+kde +testing"

PDEPEND="
	dev-libs/boost
	dev-util/ccache
	dev-util/cppcheck
	dev-util/flawfinder
	dev-util/lcov

	kde? (
		dev-util/kdevelop
		kde-apps/kcachegrind
	)
	!kde? (
		dev-qt/qt-creator[cmake,git,valgrind]
	)

	testing? (
		dev-cpp/gtest
	)
"
