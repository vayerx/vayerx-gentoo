# Copyright 1999-2019 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit slotted-boost-build-r71

BOOST_BUILD_PATCHES=(
	1.48.0-disable_python_rpath.patch
	1.49.0-darwin-gentoo-toolchain.patch
	1.54.0-fix-test.patch
	1.66.0-add-none-feature-options.patch
	1.71.0-respect-c_ld-flags.patch
)
