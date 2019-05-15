# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit cmake-multilib toolchain-funcs git-r3

DESCRIPTION="Multi-format archive and compression library"
HOMEPAGE="http://www.libarchive.org/"
EGIT_REPO_URI="https://github.com/libarchive/libarchive.git"

LICENSE="BSD BSD-2 BSD-4 public-domain"
SLOT="0/13"
KEYWORDS=""
IUSE="acl +bzip2 +e2fsprogs expat +iconv kernel_linux libressl +lz4 +lzma +lzo nettle static-libs +threads xattr +zlib zstd"

RDEPEND="
	acl? ( virtual/acl )
	bzip2? ( app-arch/bzip2 )
	expat? ( dev-libs/expat )
	!expat? ( dev-libs/libxml2 )
	iconv? ( virtual/libiconv )
	kernel_linux? (
		xattr? ( sys-apps/attr )
	)
	!libressl? ( dev-libs/openssl:0= )
	libressl? ( dev-libs/libressl:0= )
	lz4? ( >=app-arch/lz4-0_p131:0= )
	lzma? ( app-arch/xz-utils[threads=] )
	lzo? ( >=dev-libs/lzo-2 )
	nettle? ( dev-libs/nettle:0= )
	zlib? ( sys-libs/zlib )
	zstd? ( app-arch/zstd )
"

DEPEND="${RDEPEND}
	kernel_linux? (
		virtual/os-headers
		e2fsprogs? ( sys-fs/e2fsprogs )
	)
"

PATCHES=(
	"${FILESDIR}"/${PN}-3.3.3-libressl.patch
	"${FILESDIR}"/${PN}-9999-gentoo_build.patch
)

# Various test problems, starting with the fact that sandbox
# explodes on long paths. https://bugs.gentoo.org/598806
RESTRICT="test"

multilib_src_configure() {
	local build_tools=$(multilib_is_native_abi && echo ON || echo OFF)
	local mycmakeargs=(
		-DENABLE_ACL="$(usex acl)"
		-DENABLE_BZip2="$(usex bzip2)"
		-DENABLE_EXPAT="$(usex expat)"
		-DENABLE_ICONV="$(usex iconv)"
		-DENABLE_LIBXML2="$(usex !expat)"
		-DENABLE_LZ4="$(usex lz4)"
		-DENABLE_LZMA="$(usex lzma)"
		-DENABLE_LZO="$(usex lzo )"
		-DENABLE_NETTLE="$(usex nettle)"
		-DENABLE_XATTR="$(usex xattr)"
		-DENABLE_ZLIB="$(usex zlib)"
		-DENABLE_ZSTD="$(usex zstd)"
		-DENABLE_CAT="${build_tools}"
		-DENABLE_CPIO="${build_tools}"
		-DENABLE_TAR="${build_tools}"
		-DENABLE_CAT_SHARED="$(usex !static-libs)"
		-DENABLE_CPIO_SHARED="$(usex !static-libs)"
		-DENABLE_TAR_SHARED="$(usex !static-libs)"
	)

	cmake-utils_src_configure
}

multilib_src_compile() {
	if multilib_is_native_abi ; then
		${CMAKE_MAKEFILE_GENERATOR}
	else
		${CMAKE_MAKEFILE_GENERATOR} libarchive.a
	fi
}

xmultilib_src_install() {
	if multilib_is_native_abi ; then
		${CMAKE_MAKEFILE_GENERATOR} DESTDIR="${D}" install
	else
		${CMAKE_MAKEFILE_GENERATOR} DESTDIR="${D}" libarchive/install
	fi

	# Libs.private: should be used from libarchive.pc instead
	find "${ED}" -name "*.la" -delete || die
}

multilib_src_install_all() {
	cd "${S}" || die
	einstalldocs
}
