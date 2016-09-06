# Copyright 1999-2016 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI="5"

DESCRIPTION="Meta ebuild for LXDE, the Lightweight X11 Desktop Environment"
HOMEPAGE="http://lxde.sf.net/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mate +xfce"

PDEPEND="
	>=x11-misc/obconf-2.0.3_p20111019
	x11-misc/obkey

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
"

RDEPEND="
	lxde-base/lxappearance
	lxde-base/lxde-common
	lxde-base/lxde-icon-theme
	lxde-base/lxinput
	lxde-base/lxmenu-data
	lxde-base/lxpanel
	lxde-base/lxrandr
	>=lxde-base/lxsession-0.5
	>=x11-libs/libfm-1.2.4
	lxde-base/menu-cache
	x11-misc/obmenu
	x11-misc/pcmanfm
	x11-wm/openbox
"

pkg_postinst() {
	elog "For your convenience you can review the LXDE Configuration HOWTO at"
	elog "https://www.gentoo.org/proj/en/desktop/lxde/lxde-howto.xml"
}
