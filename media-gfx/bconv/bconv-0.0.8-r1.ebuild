# Copyright 1999-2020 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

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
