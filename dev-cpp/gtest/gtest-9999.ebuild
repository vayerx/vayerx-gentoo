# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4
PYTHON_DEPEND="2"

inherit python libtool

DESCRIPTION="Google C++ Testing Framework"
HOMEPAGE="http://code.google.com/p/googletest/"
if [[ "${PV}" = 9999* ]]; then
	inherit autotools subversion
	GTEST_REV="629"
	ESVN_REPO_URI="http://googletest.googlecode.com/svn/trunk@${GTEST_REV}"
	ESVN_PROJECT="gtest"
	KEYWORDS=""
else
	SRC_URI="http://googletest.googlecode.com/files/${P}.zip"
fi

LICENSE="BSD"
SLOT="0"
IUSE="examples threads static-libs"

DEPEND="app-arch/unzip"
RDEPEND=""

pkg_setup() {
	python_pkg_setup
	python_set_active_version 2
}

src_prepare() {
	# Oh, Dear God, You can't imagine how much do I hate autotools
	eautoreconf

	sed -i -e "s|/tmp|${T}|g" test/gtest-filepath_test.cc || die
	sed -i -r \
		-e '/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|' \
		Makefile.in
	elibtoolize

	python_convert_shebangs -r 2 .
}

src_configure() {
	econf \
		$(use_enable static-libs static) \
		$(use_with threads pthreads)
}

src_test() {
	# explicitly use parallel make
	emake check || die
}

src_install() {
	default
	dobin scripts/gtest-config

	if ! use static-libs ; then
		rm "${ED}"/usr/lib*/*.la || die
	fi

	if use examples ; then
		insinto /usr/share/doc/${PF}/examples
		doins samples/*.{cc,h}
	fi
}
