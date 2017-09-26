# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

PYTHON_COMPAT=( python2_7 python3_{4,5,6} pypy )
inherit python-any-r1 cmake-multilib

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

LICENSE="BSD"
SLOT="0"
IUSE="examples +threads +static-libs gmock"

RDEPEND="gmock? ( !dev-cpp/gmock )"

PATCHES=(
	"${FILESDIR}"/${P}-fix-gcc6-undefined-behavior.patch
)

multilib_src_configure() {
	local mycmakeargs=(
		-DBUILD_GTEST="ON"
		-DBUILD_GMOCK="$(usex gmock)"
		-DBUILD_SHARED_LIBS="$(usex static-libs OFF ON)"
		-Dgtest_disable_pthreads="$(usex threads OFF ON)"
		-Dgtest_build_samples="$(usex examples)"
                -DPYTHON_EXECUTABLE="${PYTHON}"
	)

	cmake-utils_src_configure
}

multilib_src_install_all() {
	einstalldocs

	if use examples; then
		docinto examples
		dodoc googletest/samples/*.{cc,h}
	fi
}
