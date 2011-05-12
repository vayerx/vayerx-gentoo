# Copyright 1999-2009 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit eutils

DESCRIPTION="MTPFS is a Fuse filesystem based on libmtp"
HOMEPAGE="http://adebenham.com/mtpfs"
SRC_URI="http://www.adebenham.com/debian/mtpfs_${PV}.orig.tar.gz"
S="${WORKDIR}/mtpfs-${PV}.orig" 

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~x86 ~amd64"
IUSE=""

DEPEND="sys-fs/fuse
      >=dev-libs/glib-2.18.4-r1
      media-libs/libmtp"
RDEPEND="${DEPEND}"

src_configure() {
   econf || die 'econf failed'
}

src_compile() {
   emake || die 'emake failed'
}

src_install() {
   emake DESTDIR="${D}" install || die 'installation failed'
   dodoc AUTHORS INSTALL NEWS README ChangeLog
}

pkg_postinst() {
   einfo "To mount your MTP device, issue:"
   einfo " /usr/bin/mtpfs <mountpoint>"
   einfo
   einfo "To unmount your MTP device, issue:"
   einfo " /usr/bin/fusermount -u <mountpoint>"
} 
