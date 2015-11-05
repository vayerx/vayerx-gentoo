# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils

DESCRIPTION="Git extension for versioning large files"
HOMEPAGE="https://git-lfs.github.com/"
SRC_URI="https://github.com/github/git-lfs/archive/v${PV}.tar.gz -> git-lfs-${PV}.tar.gz"
RESTRICT="mirror"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64"
IUSE=""

DEPEND="sys-devel/gcc[go]"
RDEPEND="${DEPEND}"

src_compile() {
	./script/bootstrap || die "bootstrap failed"
}

src_install() {
	dobin bin/git-lfs
	dodoc docs/README.md
}
