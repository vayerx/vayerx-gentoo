# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

DESCRIPTION="Meta ebuild for LXDE, the Lightweight X11 Desktop Environment"
HOMEPAGE="http://lxde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mate +xfce"

RDEPEND="
	x11-misc/obconf
	x11-misc/obkey
	x11-misc/obmenu

	mate? (
		mate-base/caja
		mate-extra/mate-system-monitor
		x11-terms/mate-terminal
	)

	xfce? (
		xfce-base/thunar
		xfce-extra/thunar-volman
		x11-terms/xfce4-terminal

		!mate? (
			xfce-extra/xfce4-taskmanager
		)
	)

	!mate? (
		!xfce? (
			lxde-base/lxtask
			lxde-base/lxterminal
		)
	)

	lxde-base/lxappearance
	lxde-base/lxde-common
	lxde-base/lxde-icon-theme
	lxde-base/lxinput
	lxde-base/lxmenu-data
	lxde-base/lxpanel
	lxde-base/lxrandr
	lxde-base/lxsession
	>=x11-libs/libfm-1.2.4
	lxde-base/menu-cache
	x11-misc/pcmanfm
	x11-wm/openbox
"

pkg_postinst() {
	elog "For your convenience you can review the LXDE Configuration HOWTO at"
	elog "https://www.gentoo.org/proj/en/desktop/lxde/lxde-howto.xml"
}
