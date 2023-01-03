# Copyright 1999-2023 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby27 ruby30 ruby31"

inherit ruby-fakegem

DESCRIPTION="Embeddable DSL library for declaring and using command-line options/flags."
HOMEPAGE="http://rubyforge.org/projects/optiflag"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RUBY_FAKEGEM_EXTRAINSTALL="./"