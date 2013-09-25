# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="4"

S=${WORKDIR}
DESCRIPTION="Meta package for the GNOME desktop, merge this package to install"
HOMEPAGE="http://www.gnome.org/"
LICENSE="HPND"
SLOT="2.0"
IUSE="+automount"

KEYWORDS="amd64 x86"

RDEPEND="!<x11-libs/gtk+-3.2.4-r1:3
	!gnome-base/gnome

	>=dev-libs/glib-2.26.1:2
	>=x11-libs/gtk+-2.22.1-r1:2
	>=x11-libs/gdk-pixbuf-2.22.1:2
	>=dev-libs/atk-1.32.0
	>=x11-libs/pango-1.28.3

	>=gnome-base/orbit-2.14.19:2

	>=x11-libs/libwnck-2.30.6:1
	>=x11-wm/metacity-2.30.3

	>=gnome-base/gconf-2.32.0-r1:2
	>=gnome-base/dconf-0.5.1-r2

	>=gnome-base/libbonobo-2.24.3
	>=gnome-base/libbonoboui-2.24.4
	>=gnome-base/libgnome-2.32.0
	>=gnome-base/libgnomecanvas-2.30.2
	>=gnome-base/libglade-2.6.4:2.0

	>=gnome-base/gnome-settings-daemon-2.32.1
	>=gnome-base/gnome-control-center-2.32.0

	>=gnome-base/nautilus-2.32.1

	>=gnome-base/gnome-desktop-2.32.1:2
	>=gnome-base/gnome-session-2.32.1
	>=gnome-base/gnome-panel-2.32.1

	>=x11-themes/gnome-icon-theme-2.31.0
	>=x11-themes/gnome-themes-2.32.1-r1
	>=x11-themes/gnome-themes-standard-3.0.2

	x11-terms/xfce4-terminal

	>=gnome-base/librsvg-2.32.1:2

	app-admin/system-config-printer-gnome
	gnome-base/gdm
	gnome-base/gnome-applets
	gnome-extra/fast-user-switch-applet
	gnome-extra/gconf-editor
	gnome-extra/gnome-media
	gnome-extra/gnome-power-manager
	gnome-extra/gnome-system-monitor
	gnome-extra/gnome-utils
	gnome-extra/nm-applet
	net-analyzer/gnome-netstatus
	net-analyzer/gnome-nettool
"

DEPEND=""
PDEPEND=">=gnome-base/gvfs-1.6.6
	automount? ( || ( >=gnome-base/gvfs-1.6.6[gdu] >=gnome-base/gvfs-1.6.6[udisks] ) )"
