# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

inherit ruby-fakegem

DESCRIPTION="Yet another ImageMagick hardcore gui-frontend with multi-processing."
HOMEPAGE="https://github.com/vayerx/bconv"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	>=dev-ruby/parseconfig-1.0.8
	dev-ruby/ruby-gtk3
"

RUBY_FAKEGEM_EXTRAINSTALL="data"
