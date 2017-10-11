# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6

inherit eutils multilib rpm versionator

DESCRIPTION="SafeNet (Aladdin) eTokens Middleware (PRO, NG OTP, Flash, Java)"

MY_PN="SafenetAuthenticationClient"
MY_PV="${PV/_p/-}"

MY_P_STD="${MY_PN}-${MY_PV}"
MY_P_COMPAT="SAC-32-CompatibilityPack-${MY_PV}"
SRC_URI="${MY_P_STD}.x86_64.rpm ${MY_P_COMPAT}.x86_64.rpm"

HOMEPAGE="http://aladdin-rd.ru"
LICENSE="EULA"
RESTRICT="fetch"
SLOT="0"
KEYWORDS="~amd64"
IUSE="+ssl"

RDEPEND="
	>=sys-apps/pcsc-lite-1.4.99
	virtual/libusb:0
	sys-apps/dbus
	media-libs/libpng:0
	media-libs/fontconfig
	ssl? ( dev-libs/libp11 )
	!app-crypt/pkiclient
"
DEPEND="${RDEPEND}"

S="${WORKDIR}"

src_unpack() {
	default

	rpm_unpack "${MY_P_STD}.x86_64.rpm"
	rpm_unpack "${MY_P_COMPAT}.x86_64.rpm"
}

src_prepare() {
	default

	cp "${FILESDIR}/SACSrv.init" etc/init.d/SACSrv
}

src_install() {
	local usb_readers_dir="usr/$(get_libdir)/readers/usb"

	mv lib lib32
	mkdir lib
	mv lib32/udev lib/udev
	mv usr/lib usr/lib32

	find usr/lib32 -type l | while read lib; do
		nlib=$(readlink -f ${lib})
		ln -sf "${nlib/\/lib\//\/lib32\/}" "${lib}"
	done

	mkdir -p "${usb_readers_dir}"
	ln -s "../../../share/eToken/drivers/aks-ifdh.bundle" "${usb_readers_dir}/aks-ifdh.bundle"

	pushd usr/share/eToken/drivers/aks-ifdh.bundle/Contents/Linux
		# TODO glob
		ln -s libAksIfdh.so{.$(get_version_component_range 1-2),}
	popd

	mkdir -p etc/conf.d/
	touch etc/conf.d/SACSrv

	mv usr/share/doc/eToken usr/share/doc/${P}

	mv * "${D}/"
}

pkg_postinst() {
	einfo "usermod -aG usb pcscd"
	einfo ""
	einfo "rc-update add SACSrv default"
	einfo ""
	einfo "If you need some help, you can ask the help in that article:"
	einfo "http://www.it-lines.ru/blogs/linux/nastrojka-etoken-v-gentoo-linux"
}
