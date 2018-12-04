# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="Implementation of Jaro-Winkler distance algorithm"
HOMEPAGE="https://github.com/tonytonyjan/jaro_winkler"

LICENSE="MIT"
KEYWORDS="~amd64"
SLOT="0"

DEPEND="
	dev-ruby/bundler
	dev-ruby/minitest
	dev-ruby/rake
	dev-ruby/rake-compiler
"

each_ruby_configure() {
	${RUBY} -Cext/${PN} extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext/${PN}
	cp ext/${PN}/${PN}_ext$(get_modname) lib/${PN}/ || die
}
