# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

inherit gnome2

DESCRIPTION="Hard disk drive health inspection tool"
HOMEPAGE="http://gsmartcontrol.berlios.de/"
SRC_URI="http://download.berlios.de/gsmartcontrol/${P}.tar.bz2"
LICENSE="|| ( GPL-2 GPL-3 ) Boost-1.0 BSD LGPL-2.1 ZLIB"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-cpp/gtkmm
	>=x11-libs/gtk+-2.12:2
	dev-libs/libpcre
	sys-apps/smartmontools"
RDEPEND="${DEPEND}
	virtual/pkgconfig"

DOCS="AUTHORS.txt ChangeLog NEWS README.txt"

G2CONF="--enable-debug-options=none
	--enable-optimize-options=none
	--disable-gcc-pch
	--disable-test
	--disable-libglade
	--docdir=/usr/share/doc/${PF}"

src_install() {
	gnome2_src_install

	rm "${D}/usr/share/doc/${PF}"/LICENSE_*
}
