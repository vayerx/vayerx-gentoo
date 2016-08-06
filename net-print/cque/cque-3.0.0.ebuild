# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

inherit unpacker versionator

DESCRIPTION="Canon CQue Linux Driver"
HOMEPAGE="http://software.canon-europe.com/"
SRC_URI="CQue_v${PV}_Linux_32_64_EN.tar.zip"

MY_PV="$(get_version_component_range 1-2)-$(get_version_component_range 3)"

LICENSE=""
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="gui"
RESTRICT="fetch"

RDEPEND="
	gui? (
		app-arch/bzip2
		app-crypt/mit-krb5
		dev-libs/expat
		dev-libs/gmp
		dev-libs/libbsd
		dev-libs/libtasn1
		dev-libs/nettle
		media-libs/fontconfig
		media-libs/freetype
		media-libs/libpng:1.2
		net-dns/libidn
		net-libs/gnutls
		sys-apps/keyutils
		sys-libs/e2fsprogs-libs
		sys-libs/zlib
		virtual/jpeg:62
		x11-libs/libICE
		x11-libs/libSM
		x11-libs/libX11
		x11-libs/libXau
		x11-libs/libxcb
		x11-libs/libXdmcp
		x11-libs/libXext
		x11-libs/libXft
		x11-libs/libXmu
		x11-libs/libXrender
		x11-libs/libXt
	)

	net-print/cups
	net-print/foomatic-db
	net-print/foomatic-db-ppds
"

S=${WORKDIR}/cque-en-${MY_PV}
DESTDIR="/opt/cel"

pkg_nofetch() {
	einfo "Please go to: ${HOMEPAGE}"
	einfo "and download the appropriate package to:"
	einfo "${DISTDIR}/${A}"
}

src_unpack() {
	default

	if use amd64; then
		unpacker "${WORKDIR}/CQue_v${PV}_Linux_32_64_EN.tar/CQue_v${PV}_Linux_64_EN.tar.gz"
	else
		unpacker "${WORKDIR}/CQue_v${PV}_Linux_32_64_EN.tar/CQue_v${PV}_Linux_32_EN.tar.gz"
	fi
}

src_install() {
	into ${DESTDIR}
	dobin sicgsfilter sicnc
	use gui && dobin CQue.exe

	insinto ${DESTDIR}
	doins -r doc images ppd

	dosym ${DESTDIR}/ppd /usr/share/cups/model/cque

	dosym ${DESTDIR}/bin/sicgsfilter /usr/bin/sicgsfilter
}
