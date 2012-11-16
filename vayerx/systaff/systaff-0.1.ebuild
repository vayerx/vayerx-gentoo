# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="System staff meta"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="+rich gnome lxde"

PDEPEND="
	rich? (
		app-portage/g-cpan
		net-analyzer/nettop
		net-analyzer/nmap
		net-analyzer/wireshark
		net-misc/proxytunnel
		sys-apps/dmidecode
		sys-fs/fuseiso
	)

	|| (
		gnome? ( gnome-base/gdm )
		lxde? ( lxde-base/lxdm )
		x11-misc/slim
	)
"
