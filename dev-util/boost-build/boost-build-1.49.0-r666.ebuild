# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"
PYTHON_DEPEND="python? *"

inherit eutils flag-o-matic python toolchain-funcs versionator

MY_PV=$(replace_all_version_separators _)

DESCRIPTION="A system for large project software construction, which is simple to use and powerful."
HOMEPAGE="http://www.boost.org/doc/tools/build/index.html"
SRC_URI="mirror://sourceforge/boost/boost_${MY_PV}.tar.bz2"

LICENSE="Boost-1.0"
SLOT="$(get_version_component_range 1-2)"
KEYWORDS="~x86 ~amd64"
IUSE="examples python"

DEPEND="!<dev-libs/boost-1.34.0
	!<=dev-util/boost-build-1.35.0-r1"
RDEPEND="${DEPEND}"

S="${WORKDIR}/boost_${MY_PV}/tools/build/v2"

MAJOR_PV="$(replace_all_version_separators _ ${SLOT})"

src_unpack() {
	tar xjpf "${DISTDIR}/${A}" boost_${MY_PV}/tools/build/v2 || die "unpacking tar failed"
}

src_prepare() {
	epatch "${FILESDIR}/${PN}-1.48.0-support_dots_in_python-buildid.patch"
	epatch "${FILESDIR}/${PN}-1.48.0-disable_python_rpath.patch"

	# Remove stripping option
	cd "${S}/engine"
	sed -i -e 's|-s\b||' \
		build.jam || die "sed failed"

	# Force regeneration
	rm jambase.c || die

	# This patch allows us to fully control optimization
	# and stripping flags when bjam is used as build-system
	# We simply extend the optimization and debug-symbols feature
	# with empty dummies called 'none'
	cd "${S}"
	sed -i \
		-e 's/\(off speed space\)/\1 none/' \
		-e 's/\(debug-symbols      : on off\)/\1 none/' \
		tools/builtin.jam || die "sed failed"
}

src_configure() {
	if use python; then
		# replace versions by user-selected one (TODO: fix this when slot-op
		# deps are available to always match the best version available)
		sed -i \
			-e "s|2.7 2.6 2.5 2.4 2.3 2.2|${PYTHON_ABI}|" \
			engine/build.jam || die "sed failed"
	fi
}

src_compile() {
	cd engine

	local toolset

	if [[ ${CHOST} == *-darwin* ]] ; then
		toolset=darwin
	else
		# Using boost's generic toolset here, which respects CC and CFLAGS
		toolset=cc
	fi

	# For slotting
	sed -i \
		-e "s|/usr/share/boost-build|/usr/share/boost-build-${MAJOR_PV}|" \
		Jambase || die "sed failed"

	# The build.jam file for building bjam using a bootstrapped jam0 ignores
	# the LDFLAGS env var (bug #209794). We have now two options:
	# a) change the cc-target definition in build.jam to include separate compile
	#    and link targets to make it use the LDFLAGS var, or
	# b) a simple dirty workaround by injecting the LDFLAGS in the LIBS env var
	#    (which should not be set by us).
	if [[ -z "${LDFLAGS}" ]] ; then
		CC=$(tc-getCC) ./build.sh ${toolset} $(use_with python) \
			|| die "building bjam failed"
	else
		LDFLAGS=$(echo ${LDFLAGS}) # 293652
		LIBS=${LDFLAGS} CC=$(tc-getCC) ./build.sh ${toolset} \
			$(use_with python) || die "building bjam failed"
	fi
}

src_install() {
	newbin engine/bin.*/bjam bjam-${MAJOR_PV}
	newbin engine/bin.*/b2 b2-${MAJOR_PV}

	cd "${S}"
	insinto /usr/share/boost-build-${MAJOR_PV}
	doins -r boost-build.jam bootstrap.jam build-system.jam site-config.jam user-config.jam \
		build kernel options tools util || die

	dodoc changes.txt hacking.txt release_procedure.txt \
		notes/build_dir_option.txt notes/relative_source_paths.txt

	if use examples; then
		insinto /usr/share/doc/${PF}
		doins -r example
	fi
}

src_test() {
	cd test/engine

	# FIXME: Replace the ls call with the proper way of doing this.

	BJAM_BIN=$(ls ../../engine/bin.*/b2)
	${BJAM_BIN} -f test.jam "-sBJAM=${BJAM_BIN}" || die "tests failed"
}

pkg_postinst() {
	use python && python_mod_optimize /usr/share/boost-build-${MAJOR_PV}
}

pkg_postrm() {
	use python && python_mod_cleanup /usr/share/boost-build-${MAJOR_PV}
}
