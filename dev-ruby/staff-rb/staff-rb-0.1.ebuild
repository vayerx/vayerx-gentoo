# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Miscellaneous Ruby staff, vayerx edition"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="database exotic +testing"

PDEPEND="
	dev-ruby/libxml
	dev-ruby/nokogiri
	dev-ruby/rake
	dev-ruby/ruby-libglade2
	dev-ruby/rubygems

	database? (
		dev-ruby/sqlite3-ruby
	)
	testing? (
		dev-ruby/zentest
	)

	exotic? (
		dev-ruby/mechanize
	)
"
