# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

PYTHON_COMPAT=( python2_7 )
inherit python-r1 cmake-utils

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="https://github.com/google/googletest"
if [[ "${PV}" = 9999* ]]; then
	inherit git-r3
	EGIT_REPO_URI="https://github.com/google/googletest.git"
	ESVN_PROJECT="gtest"
	KEYWORDS=""
	S="${WORKDIR}/${P}"
else
	SRC_URI="https://github.com/google/googletest/archive/release-${PV}.tar.gz -> ${P}.tar.gz"
	KEYWORDS="~amd64"
	S="${WORKDIR}/googletest-release-${PV}"
fi

LICENSE="googletest"
SLOT="0"
IUSE="examples +threads static-libs gmock"

RDEPEND=""

src_configure() {
	local mycmakeargs=(
		-DBUILD_GTEST="ON"
		-DBUILD_GMOCK="$(usex gmock)"
		-DBUILD_SHARED_LIBS="$(usex static-libs OFF ON)"
		-Dgtest_disable_pthreads="$(usex threads OFF ON)"
		-Dgtest_build_samples="$(usex examples)"
	)

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install
}
