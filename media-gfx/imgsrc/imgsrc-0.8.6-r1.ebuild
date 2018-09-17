# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

inherit ruby-fakegem eutils

DESCRIPTION="Simple client for imgsrc.ru photo-hosting."
HOMEPAGE="https://github.com/vayerx/imgsrc"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-ruby/libxml-2.2
	>=dev-ruby/optiflag-0.7-r1
	>=dev-ruby/parseconfig-1.0.4-r1
"
