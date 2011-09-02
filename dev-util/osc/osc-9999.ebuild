# Copyright 1999-2011 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3
inherit distutils eutils git-2

DESCRIPTION="Commandline client for the openSUSE build service"
HOMEPAGE="http://en.opensuse.org/Build_Service/CLI"
SRC_URI=""
EGIT_REPO_URI="git://gitorious.org/opensuse/osc.git"

LICENSE="GPL-2"
KEYWORDS=""
SLOT="0"
IUSE=""

RDEPEND="
	dev-python/urlgrabber
	dev-python/m2crypto"
DEPEND="$RDEPEND \
	dev-vcs/git"

src_install() {
	DOCS="AUTHORS NEWS README TODO"
	distutils_src_install
	dosym /usr/bin/{osc-wrapper.py,osc}
}
