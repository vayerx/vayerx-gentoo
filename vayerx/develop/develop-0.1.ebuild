# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Development meta package"
HOMEPAGE="http://github.com/vayerx"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="+cpp ruby +python database postgres exotic math +network rich +testing"

PDEPEND="
	cpp? (
		dev-cpp/cppstaff[rich?,exotic?,testing?]
		sys-devel/gcc[cxx]
	)

	ruby? (
		dev-lang/ruby
		dev-ruby/staff-rb[database?,exotic?,testing?]
	)

	python? (
		dev-lang/python
		dev-python/pystaff[database?,exotic?,testing?]
		dev-python/spyder[pylint,sphinx]
	)

	postgres? (
		dev-db/pgadmin3
		dev-db/postgresql-server
	)

	math? (
		sci-mathematics/qtoctave
	)

	sci-calculators/galculator
	sci-visualization/gnuplot

	dev-util/geany
	dev-util/meld

	dev-util/strace
	sys-apps/dstat
	sys-process/htop
	sys-process/iotop

	network? (
		net-analyzer/nettop
		net-analyzer/wireshark
		net-analyzer/tcpdump
		net-analyzer/traceroute
		rich? ( net-analyzer/wireshark )
		net-dns/bind-tools
		net-misc/netkit-telnetd
	)

	dev-vcs/git[doc,tk]
	dev-vcs/gitflow
	dev-vcs/gitg
"
