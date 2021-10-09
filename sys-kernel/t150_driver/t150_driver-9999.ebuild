# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit git-r3 linux-info linux-mod udev

DESCRIPTION="A linux kernel module for Thrustmaster T150 Force Feedback Wheel"
HOMEPAGE="https://github.com/scarburato/t150_driver"
EGIT_REPO_URI="https://github.com/scarburato/t150_driver"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS=""

BUILD_TARGETS="all"
MODULE_NAMES="hid-t150(kernel/drivers/hid:${S}/hid-t150)"

# CONFIG_CHECK="~HID_THRUSTMASTER"

src_compile() {
	BUILD_PARAMS="KDIR=${KV_OUT_DIR} M=${S}"
	linux-mod_src_compile
}

src_install() {
	linux-mod_src_install
	udev_dorules "${FILESDIR%/}/90-thrustmaster-t150.rules"
}

pkg_postinst() {
	if linux_config_exists && ! linux_chkconfig_present HID_THRUSTMASTER; then
		ewarn "CONFIG_HID_THRUSTMASTER should be enabled or tm-init should be manually installed"
	fi

	udev_reload
}