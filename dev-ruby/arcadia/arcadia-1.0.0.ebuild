# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI="5"
USE_RUBY="ruby20"

inherit ruby-fakegem

DESCRIPTION="Arcadia is a light IDE for Ruby language written in Ruby using the classic Tcl/Tk GUI toolkit."
HOMEPAGE="http://www.arcadia-ide.org"
LICENSE="Ruby"

SLOT="0"
KEYWORDS="~amd64 ~x86"
IUSE=""

RDEPEND="
	dev-lang/ruby[tk]
	dev-ruby/coderay
	dev-ruby/debugger
	dev-util/ctags
	sys-apps/ack
	virtual/rubygems
	x11-misc/xdotool
	x11-terms/xterm
"

RUBY_FAKEGEM_EXTRAINSTALL="./"

src_install() {
	ruby-ng_src_install
	doicon "${FILESDIR}/arcadia.png"
	make_desktop_entry /usr/bin/${PN} "Arcadia IDE" "arcadia.png" "Development"
}
