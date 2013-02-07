# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=4

inherit libtool

DESCRIPTION="Google's C++ mocking framework"
HOMEPAGE="http://code.google.com/p/googlemock/"

if [[ "${PV}" = 9999* ]]; then
	inherit autotools subversion
	GMOCK_REV="410"
	ESVN_REPO_URI="http://googlemock.googlecode.com/svn/trunk@${GMOCK_REV}"
	ESVN_PROJECT="gmock"
else
	SRC_URI="http://googlemock.googlecode.com/files/${P}.zip"
fi

LICENSE="BSD"
SLOT="0"
KEYWORDS="~amd64 ~arm ~mips ppc ~ppc64 x86"
IUSE="static-libs"

RDEPEND="=dev-cpp/gtest-${PV}*"
DEPEND="app-arch/unzip
	${RDEPEND}"

src_prepare() {
	# Oh, Dear God, You can't imagine how much do I hate autotools
	eautoreconf

	sed -i -r \
		-e '/^install-(data|exec)-local:/s|^.*$|&\ndisabled-&|' \
		Makefile.in
	elibtoolize
}

src_configure() {
	econf $(use_enable static-libs static)
}

src_install() {
	default
	dobin scripts/gmock-config
	use static-libs || find "${D}" -name '*.la' -delete
}
