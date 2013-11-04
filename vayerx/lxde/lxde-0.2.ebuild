# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

DESCRIPTION="Meta ebuild for LXDE, the Lightweight X11 Desktop Environment"
HOMEPAGE="http://lxde.sf.net/"

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="+xfce gnome"

PDEPEND="
	>=x11-misc/obconf-2.0.3_p20111019
	x11-misc/obkey

	gnome? (
		gnome-base/nautilus
		gnome-extra/gnome-system-monitor
		x11-terms/gnome-terminal
	)

	xfce? (
		xfce-base/thunar
		x11-terms/xfce4-terminal

		!gnome? (
			xfce-extra/xfce4-taskmanager
		)
	)

	!gnome? (
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
	lxde-base/lxsession
	lxde-base/lxsession-edit
	lxde-base/lxshortcut
	x11-misc/obmenu
	x11-misc/pcmanfm
	x11-wm/openbox
"

pkg_postinst() {
	elog "For your convenience you can review the LXDE Configuration HOWTO at"
	elog "http://www.gentoo.org/proj/en/desktop/lxde/lxde-howto.xml"
}
