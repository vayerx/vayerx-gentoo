# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit multilib

DESCRIPTION="boost module for eselect"
HOMEPAGE="https://www.gentoo.org/proj/en/eselect/"
SRC_URI=""

LICENSE="GPL-2"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
DEPEND=""
RDEPEND="app-admin/eselect"

S="${WORKDIR}"
src_install() {
	local mdir="/usr/share/eselect/modules"

	dodir ${mdir}
	insinto ${mdir}
	doins "${FILESDIR}/boost.eselect"

	keepdir /etc/eselect/boost
	keepdir /usr/share/boost-eselect/profiles
}
