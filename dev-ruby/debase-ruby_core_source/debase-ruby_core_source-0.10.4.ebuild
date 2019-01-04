# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby23 ruby24 ruby25 ruby26"

RUBY_FAKEGEM_EXTRAINSTALL="./"

inherit ruby-fakegem

DESCRIPTION="Provide Ruby core source files for C extensions that need them."
HOMEPAGE="https://github.com/os97673/debase-ruby_core_source"

LICENSE="MIT"
SLOT="0"
KEYWORDS=""
IUSE=""

RDEPEND="
	dev-ruby/archive-tar-minitar
	dev-ruby/rake
"
