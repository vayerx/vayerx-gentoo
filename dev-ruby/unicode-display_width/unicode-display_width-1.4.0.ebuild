# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby21 ruby23 ruby24 ruby25"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Determines the monospace display width of a string"
HOMEPAGE="https://github.com/janlelis/unicode-display_width"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

DEPEND="
	dev-ruby/rake
	dev-ruby/rspec
"
