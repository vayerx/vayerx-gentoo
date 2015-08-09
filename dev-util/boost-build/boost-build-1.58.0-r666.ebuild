# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"

inherit slotted-boost-build-r1

BOOST_BUILD_PATCHES=(
	1.48.0-disable_python_rpath.patch
	1.49.0-darwin-gentoo-toolchain.patch
	1.50.0-respect-c_ld-flags.patch
	1.52.0-darwin-no-python-framework.patch
	1.54.0-support_dots_in_python-buildid.patch
)
