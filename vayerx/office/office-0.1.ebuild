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
IUSE="+gnome +kde +lxde +rich"

PDEPEND="
	app-admin/keepassx
	app-editors/gedit
	app-office/libreoffice-bin
	media-fonts/arphicfonts
	media-fonts/bitstream-cyberbit
	media-fonts/corefonts
	media-fonts/cronyx-fonts
	media-fonts/dejavu
	media-fonts/droid
	media-fonts/freefonts
	media-fonts/intlfonts
	media-fonts/ja-ipafonts
	media-fonts/takao-fonts
	media-fonts/terminus-font
	media-fonts/wqy-microhei
	media-fonts/wqy-zenhei
	media-gfx/geeqie
	media-gfx/imagemagick
	media-sound/clementine
	media-sound/mpg123
	media-sound/picard
	media-video/mplayer
	net-im/psi
	net-misc/x11-ssh-askpass
	net-print/cups
	net-print/cups-pdf
	www-plugins/adobe-flash
	x11-apps/mesa-progs
	x11-base/xorg-x11
	x11-misc/xscreensaver
	x11-terms/terminal

	kde? (
		kde-base/okular
	)

	gnome? (
		app-text/evince
		gnome-extra/gnome-utils
	)

	rich? (
		mail-client/thunderbird
		www-client/firefox
	)
	!rich? (
		mail-client/thunderbird-bin
		www-client/firefox-bin
	)

	rich? (
		app-text/epdfview
		media-video/vlc
		www-client/chromium
		www-client/links
	)
"
