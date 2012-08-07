# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="System staff meta"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="+rich gnome lxde"

PDEPEND="
	app-admin/logrotate
	app-admin/pwgen
	app-admin/syslog-ng
	app-misc/mc
	app-misc/screen
	app-portage/eix
	app-portage/gentoolkit
	app-portage/layman
	app-portage/mirrorselect
	app-portage/ufed
	dev-util/strace
	net-analyzer/netcat
	net-analyzer/tcpdump
	net-analyzer/traceroute
	net-dns/bind-tools
	net-firewall/shorewall
	net-firewall/shorewall6
	net-misc/dhcpcd
	net-misc/netkit-telnetd
	net-misc/ntp
	sys-apps/dstat
	sys-apps/ethtool
	sys-apps/smartmontools
	sys-boot/grub
	sys-kernel/genkernel
	sys-kernel/gentoo-sources
	sys-power/acpid
	sys-power/cpufrequtils
	sys-power/powertop
	sys-process/htop
	sys-process/iotop
	sys-process/lsof
	sys-process/vixie-cron

	rich? (
		app-portage/g-cpan
		net-analyzer/nettop
		net-analyzer/nmap
		net-analyzer/ntop
		net-analyzer/wireshark
		net-misc/proxytunnel
		sys-apps/hdparm
		sys-block/gparted

		gnome? ( gnome-base/gdm )
		lxde? ( lxde-base/lxdm )
	)
"
