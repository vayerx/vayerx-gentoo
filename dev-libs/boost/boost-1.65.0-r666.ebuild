# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=6
PYTHON_COMPAT=( python{2_7,3_{4,5,6}} )

inherit slotted-boost-r62

BOOST_PATCHES=(
	"1.48.0-disable_icu_rpath.patch"
	"1.55.0-time_facet.patch"
	"1.55.0-context-x32.patch"
	"1.56.0-build-auto_index-tool.patch"
	"1.65.0-fix-python.patch"
)
