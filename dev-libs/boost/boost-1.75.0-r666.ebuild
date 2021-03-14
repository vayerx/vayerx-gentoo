# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

PYTHON_COMPAT=( python3_{7,8,9} )

inherit slotted-boost-r70

BOOST_PATCHES=(
	1.71.0-disable_icu_rpath.patch
	1.71.0-context-x32.patch
	1.71.0-build-auto_index-tool.patch
	# Boost.MPI's __init__.py doesn't work on Py3
	1.73-boost-mpi-python-PEP-328.patch
	# Remove annoying #pragma message
	1.73-property-tree-include.patch
	1.74-CVE-2012-2677.patch
)
