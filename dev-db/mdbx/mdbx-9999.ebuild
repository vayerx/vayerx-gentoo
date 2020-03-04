# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
inherit toolchain-funcs

DESCRIPTION="Key-value embedded data storage, fork of LMDB"
HOMEPAGE="https://github.com/ReOpen/libmdbx"
SRC_URI=""

LICENSE="OPENLDAP"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="static-libs"

if [[ "${PV}" = 9999* ]]; then
	inherit git-r3
	SRC_URI=""
	EGIT_REPO_URI="git://github.com/ReOpen/libmdbx.git"
else
	RESTRICT="mirror"
	SRC_URI="https://github.com/ReOpen/libmdbx/archive/mdbx_${PV}.tar.gz"
fi

DEPEND=""
RDEPEND="!dev-db/lmdb"

S="${WORKDIR}/${PN}-mdbx_${PV}/libraries/mdbx"

src_prepare() {
	sed -i -e "s/^CC.*/CC = $(tc-getCC)/" \
		-e "s/^CFLAGS.*/CFLAGS = ${CFLAGS}/" \
		-e "s/ar rs/$(tc-getAR) rs/" \
		-e "s:^prefix.*:prefix = /usr:" \
		-e "s:/man/:/share/man/:" \
		-e "/for f/s:lib:$(get_libdir):" \
		-e "s:shared:shared -Wl,-soname,libmdbx.so.0:" \
		"${S}/Makefile" || die
}

src_configure() {
	:
}

src_compile() {
	emake CFLAGS+=" -pthread"
}

src_install() {
	mkdir -p "${D}"/usr/{bin,$(get_libdir),include,share/man/man1}
	default

	mv "${D}"/usr/$(get_libdir)/libmdbx.so{,.0} || die
	dosym libmdbx.so.0 /usr/$(get_libdir)/libmdbx.so

	use static-libs || rm -f "${D}"/usr/$(get_libdir)/libmdbx.a
}
