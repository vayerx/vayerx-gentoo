# Copyright 1999-2013 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Miscellaneous Ruby staff, vayerx edition"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="database datamining gui"

PDEPEND="
	database? (
		dev-ruby/sqlite-ruby
	)
	gui? (
		dev-ruby/ruby-libglade2
	)
	datamining? (
		dev-ruby/mechanize
	)
"
