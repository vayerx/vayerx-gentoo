# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRAINSTALL="data"

inherit ruby-fakegem

DESCRIPTION="Determines the monospace display width of a string"
HOMEPAGE="https://github.com/janlelis/unicode-display_width"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"

DEPEND="
	dev-ruby/rake
	dev-ruby/rspec
"
