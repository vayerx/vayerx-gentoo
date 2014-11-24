# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="System staff meta"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="+rich gnome lxde kde"

PDEPEND="
	app-shells/bash-completion

	rich? (
		app-portage/g-cpan
		net-analyzer/nettop
		net-analyzer/nmap
		net-analyzer/wireshark
		sys-apps/dmidecode
		sys-fs/fuseiso
	)

	|| (
		gnome? ( gnome-base/gdm )
		lxde? ( lxde-base/lxdm )
		kde? ( kde-base/kdm )
		x11-misc/slim
	)
"
