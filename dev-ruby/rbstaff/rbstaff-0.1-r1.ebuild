# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Miscellaneous Ruby staff, vayerx edition"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="database datamining gui"

PDEPEND="
	database? (
		dev-ruby/sqlite3
	)
	gui? (
		dev-ruby/ruby-gtk3
	)
	datamining? (
		dev-ruby/mechanize
	)
"
