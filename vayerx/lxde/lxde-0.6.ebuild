# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Meta ebuild for LXDE, the Lightweight X11 Desktop Environment"
HOMEPAGE="http://lxde.org/"

LICENSE="metapackage"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE="mate +xfce"

RDEPEND="
	>=x11-misc/obconf-2.0.4
	x11-misc/obmenu-generator

	mate? (
		mate-base/caja
		mate-extra/mate-system-monitor
		x11-terms/mate-terminal
	)

	xfce? (
		xfce-base/thunar
		xfce-base/thunar-volman
		x11-terms/xfce4-terminal

		!mate? (
			xfce-extra/xfce4-taskmanager
		)
	)

	!mate? (
		!xfce? (
			>=lxde-base/lxtask-0.1.10
			>=lxde-base/lxterminal-0.3.2-r1
			media-gfx/gpicview
		)
	)

	>=lxde-base/lxappearance-0.6.3-r2
	>=lxde-base/lxde-common-0.99.2-r1
	>=lxde-base/lxde-icon-theme-0.5.1-r1
	>=lxde-base/lxinput-0.3.5-r2
	>=lxde-base/lxmenu-data-0.1.5
	>=lxde-base/lxpanel-0.10.1
	>=lxde-base/lxrandr-0.3.2-r1
	>=lxde-base/lxsession-0.5.5
	>=x11-libs/libfm-1.3.2
	lxde-base/menu-cache
	>=x11-misc/pcmanfm-1.3.2
	>=x11-wm/openbox-3.6.1-r3
"

pkg_postinst() {
	elog "For your convenience you can review the LXDE Configuration HOWTO at"
	elog "https://www.gentoo.org/proj/en/desktop/lxde/lxde-howto.xml"
}
