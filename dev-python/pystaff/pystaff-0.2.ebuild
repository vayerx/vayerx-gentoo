# Copyright 1999-2017 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Id$

EAPI=5

DESCRIPTION="Miscellaneous Python staff, vayerx edition"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="database rich +testing"

PDEPEND="
	dev-python/httplib2
	rich? (
		dev-python/git-python
		dev-python/paramiko
	)

	testing? (
		dev-python/mock
		dev-python/mox
	)

	database? (
		dev-python/sqlalchemy
	)
"

# coverage - Code coverage measurement for Python
# dev-python/git-python - Python API for Git
# mock - Python Mocking and Patching Library
# mox -  A mock object framework for Python
# paramiko - SSH2 protocol library
# sqlalchemy - Python SQL toolkit and ORM
