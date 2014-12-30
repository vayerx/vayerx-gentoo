# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
USE_RUBY="ruby20"

inherit ruby-fakegem

DESCRIPTION="A fast implementation of the standard Ruby debugger."
HOMEPAGE="https://rubygems.org/gems/debugger"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-ruby/columnize
	dev-ruby/debugger-linecache
	dev-ruby/debugger-ruby_core_source
"

RUBY_FAKEGEM_EXTRAINSTALL="./"