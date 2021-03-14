# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils flag-o-matic prefix toolchain-funcs

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="A system for large project software construction, simple to use and powerful"
HOMEPAGE="https://boostorg.github.io/build/"
SRC_URI="mirror://sourceforge/boost/boost_${MY_PV}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="examples"
RESTRICT="test"

SR="${WORKDIR}/boost_${MY_PV}/tools/build"
S="${SR}/src"

MAJOR_PV="$(ver_rs 1- _ ${SLOT})"

src_unpack() {
	tar xojf "${DISTDIR}/${A}" boost_${MY_PV%/}/tools/build || die "unpacking tar failed"
}

src_prepare() {
	pushd "${SR}" >/dev/null || die

	default

	for patch in "${BOOST_BUILD_PATCHES[@]}"; do
		eapply "${FILESDIR}/${PN}-${patch}"
	done

	# This patch allows us to fully control optimization
	# and stripping flags when bjam is used as build-system
	# We simply extend the optimization and debug-symbols feature
	# with empty dummies called 'none'
	cd "${S}" || die
	sed -e '/^cpu-flags\s*gcc\s*OPTIONS/d' \
		-e '/toolset\.flags\s*gcc\s*OPTIONS/d' \
		-e "/cpu_flags('gcc',\s*'OPTIONS'/d" \
		-i tools/gcc.{jam,py} || die "Failed removing -march/-mcpu"

	popd >/dev/null || die
}

src_configure() {
	hprefixify engine/Jambase
	tc-export CXX

	# For slotting
	sed -i \
		-e "s|/usr/share/boost-build|/usr/share/boost-build-${MAJOR_PV}|" \
		engine/Jambase || die "slotting failed"
}

src_compile() {
	cd engine || die
	CC=$(tc-getCC) ./build.sh -d+2 --without-python || die "building bjam failed"
}

src_test() {
	# Forget tests, bjam is a lost cause
	:
}

src_install() {
	newbin engine/bjam bjam-${MAJOR_PV}
	newbin engine/b2 b2-${MAJOR_PV}

	insinto /usr/share/boost-build-${MAJOR_PV}
	doins -r "${FILESDIR}/site-config.jam" \
		../boost-build.jam bootstrap.jam build-system.jam ../example/user-config.jam *.py \
		build kernel options tools util

	find "${ED%/}/usr/share/boost-build-${MAJOR_PV}" -iname '*.py' -delete || die "removing of python files failed"

	dodoc ../notes/{changes,release_procedure,build_dir_option,relative_source_paths}.txt

	if use examples; then
		docinto examples
		dodoc -r ../example/.
		docompress -x "/usr/share/doc/${PF}/examples"
	fi
}
