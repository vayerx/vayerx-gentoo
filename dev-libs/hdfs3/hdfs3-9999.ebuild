# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit cmake-utils git-r3

DESCRIPTION="A Native C/C++ HDFS Client"
HOMEPAGE="https://github.com/apache/incubator-hawq"
EGIT_REPO_URI="https://github.com/apache/incubator-hawq.git"

LICENSE="Apache-2.0"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="
	dev-cpp/gtest[gmock]
	dev-libs/libxml2
	dev-libs/protobuf
	net-libs/libgsasl[kerberos]
"
RDEPEND="${DEPEND}"

S="${S}/depends/libhdfs3"

PATCHES=(
	"${FILESDIR}/${PV}-fix_install_headers.patch"
)

src_prepare() {
	cmake-utils_src_prepare
	sed -e "s/DESTINATION lib/DESTINATION $(get_libdir)/g" -i src/CMakeLists.txt || die
}
