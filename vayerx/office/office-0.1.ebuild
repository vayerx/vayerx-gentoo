# Copyright 1999-2012 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=3

DESCRIPTION="Office staff meta"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="burn +gnome +kde +lxde +rich 32on64"

PDEPEND="
	app-admin/keepassx
	app-arch/p7zip
	app-arch/unrar
	app-arch/zip
	app-crypt/gpa
	app-crypt/gpgme
	app-office/libreoffice-bin
	app-text/aspell
	media-fonts/arphicfonts
	media-fonts/bitstream-cyberbit
	media-fonts/corefonts
	media-fonts/cronyx-fonts
	media-fonts/dejavu
	media-fonts/droid
	media-fonts/freefonts
	media-fonts/intlfonts
	media-fonts/ja-ipafonts
	media-fonts/source-pro
	media-fonts/takao-fonts
	media-fonts/terminus-font
	media-fonts/wqy-microhei
	media-fonts/wqy-zenhei
	media-gfx/geeqie
	media-gfx/gimp
	media-gfx/imagemagick
	media-sound/clementine
	media-sound/mpg123
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
	x11-themes/gentoo-artwork
	x11-themes/tango-icon-theme

	amd64? ( 32on64? ( www-plugins/nspluginwrapper ) )

	burn? (
		app-cdr/cdw
		app-cdr/xfburn

		rich? (
			app-cdr/bin2iso
			app-cdr/burn-cd
			app-cdr/cuetools
			app-cdr/iat
			app-cdr/nrg2iso
		)
	)

	kde? (
		kde-base/okular
	)

	gnome? (
		app-text/evince
		gnome-extra/gnome-utils
		app-editors/gedit
	)
	!gnome? (
		app-editors/leafpad
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
		app-text/chm2pdf
		app-text/djview
		app-text/mupdf
		app-office/dia
		media-gfx/exif
		media-gfx/exiftags
		media-sound/picard
		media-video/vlc
		x11-themes/gnome-icon-theme
		www-client/chromium
		www-client/links
		www-plugins/gnash
		www-plugins/lightspark
	)
"
