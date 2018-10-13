# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

RUBY_FAKEGEM_EXTRADOC="LICENSE.txt README.md"
RUBY_FAKEGEM_BINDIR="exe"
RUBY_FAKEGEM_EXTRAINSTALL="config"

inherit ruby-fakegem

DESCRIPTION="Automatic Ruby code style checking tool. Aims to enforce the community-driven Ruby Style Guide"
HOMEPAGE="http://www.rubocop.org/"
RDEPEND="
	>=dev-ruby/parser-2.5
	dev-ruby/jaro_winkler
	dev-ruby/parallel
	>=dev-ruby/rainbow-2.2.2
	<dev-ruby/rainbow-4
	dev-ruby/powerpack
	dev-ruby/ruby-progressbar
	dev-ruby/unicode-display_width
"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""
