# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24 ruby25"

inherit ruby-fakegem

DESCRIPTION="ruby-debug is a fast implementation of the standard Ruby debugger"
HOMEPAGE="https://github.com/denofevil/debase"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-ruby/debase-ruby_core_source
"

each_ruby_configure() {
	${RUBY} -Cext extconf.rb || die
	${RUBY} -Cext/attach extconf.rb || die
}

each_ruby_compile() {
	emake V=1 -Cext
	cp ext/${PN}_internals$(get_modname) lib/${PN}/ || die

	emake V=1 -Cext/attach
	cp ext/attach/attach$(get_modname) lib/${PN}/ || die
}
