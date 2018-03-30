# Copyright 2015-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python2_7 python3_{4,5,6} )
inherit cmake-utils python-r1

DESCRIPTION="Software framework for scalable cross-language services development"
HOMEPAGE="https://thrift.apache.org"
SRC_URI="mirror://apache/${PN}/${PV}/${P}.tar.gz"
RESTRICT="mirror"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~arm ~x86"

# Thrift 0.10.0 cmake build doesn't support other generator libraries
# TODO: as3 cocoa cpp csharp d delphi erl go hs javame js lua nodejs ocaml perl php py rb st ts
# TODO: haskell (dev-lang/ghc) support
IUSE="c_glib cpp java +libevent +openssl python qt4 qt5 static-libs +stdthreads +zlib"

RDEPEND="
	dev-libs/boost:=

	java? (
		virtual/jre:=
	)

	qt4? ( dev-qt/qtcore:4 )
	qt5? ( dev-qt/qtcore:5 )

	libevent? (
		dev-libs/libevent
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
	)

	append-cxxflags -std=c++14

	if usex static-libs; then
		mycmakeargs+=(-DWITH_STATIC_LIB=ON)
	else
		mycmakeargs+=(-DWITH_STATIC_LIB=OFF)
	fi

	for flag in ${IUSE}; do
		if [ "${flag}" != "static-libs"]; then
			mycmakeargs+=(-DWITH_${flag}="$(usex ${flag})")
		fi
	done

	cmake-utils_src_configure
}

src_install() {
	cmake-utils_src_install

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
