# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit slotted-boost-r58

BOOST_PATCHES=(
	"1.51.0-respect_python-buildid.patch"
	"1.51.0-support_dots_in_python-buildid.patch"
	"1.48.0-no_strict_aliasing_python2.patch"
	"1.48.0-disable_libboost_python3.patch"
	"1.48.0-python_linking.patch"
	"1.48.0-disable_icu_rpath.patch"
	"1.52.0-threads.patch"
	"1.55.0-time_facet.patch"
	"1.55.0-context-x32.patch"
	"1.58.0-fix-non-constexpr-types-regression.patch"
)
