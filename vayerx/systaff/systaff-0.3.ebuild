# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="System staff meta"
HOMEPAGE="https://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE="kde lxde +rich"

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
