# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

inherit eutils multilib rpm

DESCRIPTION="SafeNet (Aladdin) eTokens Middleware (PRO, NG OTP, Flash, Java)"

MY_PN="SafenetAuthenticationClient"
MY_PV="${PV/_p/-}"

MY_P_CORE="${MY_PN}-core-${MY_PV}"
SRC_URI="${MY_P_CORE}.x86_64.rpm"

HOMEPAGE="http://aladdin-rd.ru"
LICENSE="EULA"
RESTRICT="fetch"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ssl multilib"

REQUIRED_USE="amd64? ( multilib )"

RDEPEND="
	>=sys-apps/pcsc-lite-1.4.99
	virtual/libusb:0
	sys-apps/dbus
	ssl? ( dev-libs/engine_pkcs11 )
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	default

	rpm_unpack "${MY_P_CORE}.x86_64.rpm"
}

src_prepare() {
	default

	cp "${FILESDIR}/SACSrv.init" etc/init.d/SACSrv
}

src_install() {
	mv * "${D}/"
}

pkg_postinst() {
	einfo "rc-update add pcscd default"
	einfo "rc-update add SACSrv default"
	einfo ""
	einfo "If you need some help, you can ask the help in that article:"
	einfo "http://www.it-lines.ru/blogs/linux/nastrojka-etoken-v-gentoo-linux"
}
