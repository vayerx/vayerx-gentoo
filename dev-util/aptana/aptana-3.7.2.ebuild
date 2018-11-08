# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="7"
inherit eutils

DESCRIPTION="Eclipse IDE for building, editing and debugging HTML/CSS/JavaScript/PHP/Ruby on Rails."
HOMEPAGE="http://www.aptana.com"
SRC_URI="https://github.com/aptana/studio3/releases/download/${PV}.201807301111/aptana.studio-linux.gtk.x86_64.zip"

LICENSE="GPL-3"
SLOT="3"
KEYWORDS="~amd64"
RESTRICT="mirror"
IUSE=""

RDEPEND="media-libs/libjpeg-turbo
	 >=virtual/jre-1.5
	 media-libs/libpng:1.2
	 x11-libs/gtk+:2
	 sys-apps/net-tools
"

S="${WORKDIR}"

src_install() {
	dodir "/opt/${PN}"
	local dest="${D}/opt/${PN}"
	cp -pPR configuration/ features/ plugins/ "${dest}" || die "Failed to install Files"
	insinto "/opt/${PN}"
	doins icon.xpm AptanaStudio3.ini full_uninstall.txt version.txt
	exeinto "/opt/${PN}"
	doexe AptanaStudio3

	dodir /opt/bin
	echo "#!/bin/sh" > ${T}/AptanaStudio
	echo "/opt/${PN}/AptanaStudio3" >> ${T}/AptanaStudio
	dobin "${T}/AptanaStudio"

	make_desktop_entry "AptanaStudio" "Aptana Studio" "/opt/${PN}/icon.xpm" "Development"
}
