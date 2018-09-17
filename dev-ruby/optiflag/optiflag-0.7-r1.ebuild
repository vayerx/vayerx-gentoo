# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
USE_RUBY="ruby22 ruby23 ruby24"

inherit ruby-fakegem

DESCRIPTION="Embeddable DSL library for declaring and using command-line options/flags."
HOMEPAGE="http://rubyforge.org/projects/optiflag"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RUBY_FAKEGEM_EXTRAINSTALL="./"