# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="One Ring to rule them all"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="+lxde mate +development"

PDEPEND="
	development? ( vayerx/develop )
	lxde? ( vayerx/lxde )

	vayerx/systaff[lxde?,mate?]
	vayerx/office
"
