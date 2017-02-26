# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=6

DESCRIPTION="System staff meta"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="lxde kde +rich"

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
		lxde? ( lxde-base/lxdm )
		x11-misc/sddm
		x11-misc/slim
	)
"
