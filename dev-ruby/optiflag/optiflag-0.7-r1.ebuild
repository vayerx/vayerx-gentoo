# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
USE_RUBY="ruby20 ruby21 ruby22"

inherit ruby-fakegem

DESCRIPTION="Embeddable DSL library for declaring and using command-line options/flags."
HOMEPAGE="http://rubyforge.org/projects/optiflag"

SLOT="0"
KEYWORDS="amd64 ~x86"
IUSE=""

RUBY_FAKEGEM_EXTRAINSTALL="./"