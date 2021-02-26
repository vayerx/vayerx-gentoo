# Copyright 2015-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
PYTHON_COMPAT=( python2_7 python3_{6,7,8,9} )
inherit cmake-utils python-r1 perl-module

DESCRIPTION="Software framework for scalable cross-language services development"
HOMEPAGE="https://thrift.apache.org"
SRC_URI="mirror://apache/${PN}/${PV}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

# TODO: haskell (dev-lang/ghc) support
IUSE="c_glib cpp examples java js +libevent nodejs +openssl perl python qt5 static-libs +zlib"

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
	sys-devel/gcc
	sys-devel/flex
	virtual/yacc
	c_glib? ( dev-libs/glib )
"
REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
"

src_prepare() {
	cmake-utils_src_prepare
}

src_configure() {
	local mycmakeargs=(
		-DBUILD_CPP=$(usex cpp)
		-DBUILD_C_GLIB=$(usex c_glib)
		-DBUILD_JAVA=$(usex java)
		-DBUILD_JAVASCRIPT=$(usex js)
		-DBUILD_NODEJS=$(usex nodejs)
		-DBUILD_PYTHON=$(usex python)
		-DBUILD_TESTING=OFF
		-DBUILD_TUTORIALS=$(usex examples)
		-DWITH_AS3=OFF
		-DWITH_CPP=$(usex cpp)
		-DWITH_C_GLIB=$(usex c_glib)
		-DWITH_HASKELL=OFF
		-DWITH_JAVA=$(usex java)
		-DWITH_JAVASCRIPT=$(usex js)
		-DWITH_LIBEVENT=$(usex libevent)
		-DWITH_NODEJS=$(usex nodejs)
		-DWITH_OPENSSL=$(usex openssl)
		-DWITH_PYTHON=$(usex python)
		-DWITH_QT5=$(usex qt5)
		-DWITH_SHARED_LIB=ON
		-DWITH_STATIC_LIB=$(usex static-libs)
		-DWITH_ZLIB=$(usex zlib)
	)

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
