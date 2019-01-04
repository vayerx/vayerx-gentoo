# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

inherit ruby-fakegem

DESCRIPTION="A few useful extensions to core Ruby classes"
HOMEPAGE="https://github.com/bbatsov/powerpack"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

DEPEND="
	dev-ruby/bundler
	dev-ruby/rake
	dev-ruby/rspec
	dev-ruby/yard
	dev-ruby/rake-compiler
"
