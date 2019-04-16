# Copyright 1999-2019 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

inherit eutils desktop

MY_PN="RubyMine"
MY_PV="$(ver_cut 1-3)"

DESCRIPTION="The most intelligent Ruby and Rails IDE"
HOMEPAGE="http://jetbrains.com/ruby/"
SRC_URI="http://download.jetbrains.com/ruby/${MY_PN}-${MY_PV}.tar.gz"
LICENSE="JetBrains-EULA"

IUSE="+debugger +rubocop"
KEYWORDS="~amd64"
SLOT="$(ver_cut 1)"

RDEPEND="
	>=virtual/jdk-1.7
	debugger? (
		dev-ruby/ruby-debug-ide
	)
	rubocop? (
		dev-ruby/rubocop
	)
"

RESTRICT="strip"
QA_TEXTRELS="opt/${P}/bin/libbreakgen.so"

S=${WORKDIR}/${MY_PN}-${MY_PV}

src_prepare() {
	eapply_user

	rm -r jre64
}

src_install() {
	local dir="/opt/${P}"
	local exe="${PN}-${SLOT}"

	insinto "${dir}"
	doins -r *
	fperms 755 "${dir}/bin/${PN}.sh" "${dir}/bin/rinspect.sh" "${dir}/bin/fsnotifier" "${dir}/bin/fsnotifier64"

	newicon "bin/${PN}.png" "${exe}.png"
	make_wrapper "${exe}" "/opt/${P}/bin/${PN}.sh"
	make_desktop_entry ${exe} "RubyMine ${MY_PV}" "${exe}" "Development;IDE"
}
