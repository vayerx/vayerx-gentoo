# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python2_7 )
inherit eutils flag-o-matic python-single-r1 toolchain-funcs

MY_PV="$(ver_rs 1- _)"

DESCRIPTION="A system for large project software construction, simple to use and powerful"
HOMEPAGE="https://boostorg.github.io/build/"
SRC_URI="mirror://sourceforge/boost/boost_${MY_PV}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="$(ver_cut 1-2)"
KEYWORDS="~amd64"
IUSE="examples python test"
RESTRICT="test"

RDEPEND="python? ( ${PYTHON_DEPS} )"
DEPEND="${RDEPEND}
	test? (
		sys-apps/diffutils
		${PYTHON_DEPS}
	)
"

REQUIRED_USE="
	python? ( ${PYTHON_REQUIRED_USE} )
	test? ( ${PYTHON_REQUIRED_USE} )"

SR="${WORKDIR}/boost_${MY_PV}/tools/build"
S="${SR}/src"

MAJOR_PV="$(ver_rs 1- _ ${SLOT})"

pkg_setup() {
	if use python || use test; then
		python-single-r1_pkg_setup
	fi
}

src_unpack() {
	tar xojf "${DISTDIR}/${A}" boost_${MY_PV%/}/tools/build || die "unpacking tar failed"
}

src_prepare() {
	cd "${SR}"

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
}

src_configure() {
	hprefixify engine/Jambase
	tc-export CXX
}

src_compile() {
	cd engine || die

	# For slotting
	sed -i \
		-e "s|/usr/share/boost-build|/usr/share/boost-build-${MAJOR_PV}|" \
		Jambase || die "sed failed"

	CC=$(tc-getCC) ./build.sh -d+2 $(use_with python python "${ESYSROOT}"/usr) || die "building bjam failed"
}

src_test() {
	cd ../test || die

	local -x TMP="${T}"

	DO_DIFF="${EPREFIX}/usr/bin/diff" "${EPYTHON}" test_all.py

	if [[ -s test_results.txt ]]; then
		eerror "At least one test failed: $(<test_results.txt)"
		die "tests failed"
	fi
}

src_install() {
	newbin engine/bjam bjam-${MAJOR_PV}
	newbin engine/b2 b2-${MAJOR_PV}

	insinto /usr/share/boost-build-${MAJOR_PV}
	doins -r "${FILESDIR}/site-config.jam" \
		../boost-build.jam bootstrap.jam build-system.jam ../example/user-config.jam *.py \
		build kernel options tools util

	if ! use python; then
		find "${ED%/}/usr/share/boost-build-${MAJOR_PV}" -iname "*.py" -delete || die "removing experimental python files failed"
	fi

	dodoc ../notes/{changes,release_procedure,build_dir_option,relative_source_paths}.txt

	if use examples; then
		docinto examples
		dodoc -r ../example/.
		docompress -x "/usr/share/doc/${PF}/examples"
	fi

	use python && python_optimize /usr/share/boost-build-${MAJOR_PV}
}
