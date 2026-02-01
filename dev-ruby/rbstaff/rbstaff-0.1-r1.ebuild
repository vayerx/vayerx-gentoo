# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Miscellaneous Ruby staff, vayerx edition"
HOMEPAGE="https://github.com/vayerx/vayerx-gentoo"
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
