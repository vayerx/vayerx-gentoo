# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: /var/cvsroot/gentoo-x86/dev-python/nosehtmloutput/nosehtmloutput-0.0.4-r1.ebuild,v 1.7 2014/08/10 21:14:42 slyfox Exp $

EAPI=5
PYTHON_COMPAT=( python{2_6,2_7,3_2,3_3,3_4} pypy )

inherit distutils-r1

DESCRIPTION="Generate random date(time)"
HOMEPAGE="https://github.com/barseghyanartur/radar"
SRC_URI="mirror://pypi/${PN:0:1}/${PN}/${P}.tar.gz"

LICENSE="GPL 2.0 LGPL 2.1"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

DEPEND="dev-python/setuptools[${PYTHON_USEDEP}]"
RDEPEND=""
