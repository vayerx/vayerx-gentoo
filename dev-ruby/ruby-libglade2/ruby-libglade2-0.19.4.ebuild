# Copyright 1999-2010 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="2"
USE_RUBY="ruby18 ruby19"

inherit ruby-ng-gnome2

DESCRIPTION="Ruby Libglade2 bindings"
KEYWORDS="alpha amd64 ia64 ppc sparc x86"
IUSE="gnome"

RDEPEND="${RDEPEND}
	>=gnome-base/libglade-2"
DEPEND="${DEPEND}
	>=gnome-base/libglade-2
	dev-util/pkgconfig"

ruby_add_rdepend ">=dev-ruby/ruby-gtk2-${PV}
	>=dev-ruby/ruby-glib2-${PV}
	gnome? ( >=dev-ruby/ruby-gnome2-${PV} )"
