# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit slotted-boost-build-r74

BOOST_BUILD_PATCHES=(
	1.71.0-disable_python_rpath.patch
	1.71.0-darwin-gentoo-toolchain.patch
	1.73.0-add-none-feature-options.patch
	1.71.0-respect-c_ld-flags.patch
	1.74.0-no-implicit-march-flags.patch
)
