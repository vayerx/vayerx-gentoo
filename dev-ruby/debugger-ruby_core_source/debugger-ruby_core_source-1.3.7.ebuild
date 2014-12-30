# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
USE_RUBY="ruby20"

inherit ruby-fakegem

DESCRIPTION="Provide Ruby core source files for C extensions that need them."
HOMEPAGE="https://rubygems.org/gems/debugger-ruby_core_source"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-ruby/archive-tar-minitar
	dev-ruby/rake
"

RUBY_FAKEGEM_EXTRAINSTALL="./"