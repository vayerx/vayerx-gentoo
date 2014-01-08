# Copyright 1999-2014 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Office staff meta"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="burn gnome kde +lxde +rich excessive"

PDEPEND="
	burn? (
		app-cdr/bin2iso
		app-cdr/cdw
		app-cdr/iat
		app-cdr/nrg2iso
		app-cdr/cuetools

		kde? (
			app-cdr/k3b
		)
		!kde? (
			app-cdr/xfburn
		)
	)

	kde? (
		kde-base/gwenview
		kde-base/kolourpaint
		kde-base/okular
	)

	gnome? (
		!kde? (
			app-text/evince
		)
		media-gfx/gnome-screenshot
		|| (
			dev-util/geany
			app-editors/leafpad
			app-editors/gedit
		)
	)
	!gnome? (
		app-editors/leafpad
	)

	rich? (
		excessive? (
			app-office/libreoffice
		)
		!excessive? (
			app-office/libreoffice-bin
		)
		mail-client/thunderbird
		www-client/firefox
	)
	!rich? (
		app-office/libreoffice-bin
		mail-client/thunderbird-bin
		www-client/firefox-bin
	)

	rich? (
		app-emulation/q4wine
		app-emulation/winetricks
		app-text/chm2pdf
		app-text/djview
		app-text/mupdf
		app-office/dia
		media-gfx/exif
		media-gfx/exiftags
		media-sound/picard
		media-video/vlc
		x11-themes/gnome-icon-theme
		www-client/links
		www-plugins/gnash
	)
"
