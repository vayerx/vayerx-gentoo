# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
USE_RUBY="ruby19"

inherit ruby-fakegem

DESCRIPTION="Yet another ImageMagick hardcore gui-frontend with multi-processing."
HOMEPAGE="https://github.com/vayerx/bconv"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-ruby/parseconfig-1.0.4
"

RUBY_FAKEGEM_EXTRAINSTALL="data"
