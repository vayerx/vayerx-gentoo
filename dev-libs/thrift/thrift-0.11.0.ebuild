# Copyright 2015-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6,7} )
inherit cmake-utils python-r1 perl-module

DESCRIPTION="Software framework for scalable cross-language services development"
HOMEPAGE="https://thrift.apache.org"
SRC_URI="mirror://apache/${PN}/${PV}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

# TODO: haskell (dev-lang/ghc) support
IUSE="c_glib cpp examples java +libevent +openssl perl python qt5 static-libs +stdthreads +zlib"

RDEPEND="
	dev-libs/boost:=

	java? (
		virtual/jre:=
	)

	qt5? ( dev-qt/qtcore:5 )

	libevent? (
		dev-libs/libevent
	)

	perl? (
		dev-lang/perl
		dev-perl/Bit-Vector
	)

	zlib? (
		sys-libs/zlib
	)

	openssl? (
		dev-libs/openssl:=
	)

	python? ( ${PYTHON_DEPS} )
"
DEPEND="${RDEPEND}
	sys-devel/flex
	>=sys-devel/gcc-4.8
	sys-devel/flex
	virtual/yacc
	c_glib? ( dev-libs/glib )
"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

src_configure() {
	local mycmakeargs=(
		-DWITH_SHARED_LIB=ON
		-DWITH_STATIC_LIB=$(usex static-libs)
		-DBUILD_PYTHON=$(used python)
		-DBUILD_EXAMPLES=$(usex examples)
		-DBUILD_TUTORIALS=$(usex examples)
	)

	append-cxxflags -std=c++14

	for flag in ${IUSE}; do
		if [[ ! "${flag}" =~ static-libs|python_targets|examples ]]; then
			flag=${flag#+}
			mycmakeargs+=(-DWITH_${flag^^}=$(usex ${flag}))
		fi
	done

	if use perl ; then
		cd "${S}/lib/perl"
		perl-module_src_configure
	fi

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

	if use perl ; then
		cd "${S}/lib/perl"
		perl-module_src_install
	fi

	# Thrift 0.9.3 doesn't install python libs
	install_python() {
		cd "${S}/lib/py/" || die
		${EPYTHON} "${S}/lib/py/setup.py" install --root "${D}"

		python_optimize
	}
	if use python; then
		python_foreach_impl install_python
	fi

}
