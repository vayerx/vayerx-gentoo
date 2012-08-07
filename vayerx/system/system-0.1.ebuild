# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="System staff meta"
HOMEPAGE="http://github.com/vayerx"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="+rich"

PDEPEND="
	app-admin/logrotate
	app-admin/pwgen
	app-admin/syslog-ng
	app-misc/mc
	app-portage/eix
	app-portage/gentoolkit
	app-portage/layman
	app-portage/mirrorselect
	app-portage/ufed
	net-analyzer/nettop
	net-analyzer/tcpdump
	net-analyzer/traceroute
	net-dns/bind-tools
	net-firewall/shorewall
	net-firewall/shorewall6
	net-misc/dhcpcd
	net-misc/netkit-telnetd
	net-misc/ntp
	net-misc/proxytunnel
	sys-boot/grub
	sys-kernel/genkernel
	sys-kernel/gentoo-sources
	sys-power/acpid
	sys-power/cpufrequtils
	sys-process/htop

	rich? (
		net-analyzer/wireshark
		sys-block/gparted
	)
"
