# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Miscellaneous Python staff, vayerx edition"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="database exotic +testing"

PDEPEND="
	dev-python/coverage
	exotic? (
		dev-python/git-python
		dev-python/paramiko
		>=dev-python/ipython-0.11
	)
	dev-python/lxml
	dev-python/setuptools
	testing? (
		dev-python/mock
		dev-python/mox
	)
	database? (
		dev-python/sqlalchemy
	)
"

# coverage - Code coverage measurement for Python
# ipython - Advanced interactive shell for Python
# dev-python/git-python - Python API for Git
# lxml - Pythonic XML processing library
# mock - Python Mocking and Patching Library
# mox -  A mock object framework for Python
# paramiko - SSH2 protocol library
# setuptools - Extensions to Distutils
# sqlalchemy - Python SQL toolkit and ORM
