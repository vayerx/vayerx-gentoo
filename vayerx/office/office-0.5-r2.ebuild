# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

DESCRIPTION="Office staff meta"
HOMEPAGE="http://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~x86 ~amd64"
SLOT="0"
IUSE="burn gtk kde mate +rich +excessive abi_x86_32"

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
		kde-apps/gwenview
		kde-apps/kolourpaint
		kde-apps/okular
	)

	gtk? (
		dev-util/geany
	)
	!gtk? (
		app-editors/leafpad
	)

	mate? (
		x11-themes/mate-icon-theme
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
		excessive? (
			app-text/chm2pdf
		)
		app-text/djview
		app-text/mupdf
		app-office/dia
		media-gfx/exif
		media-gfx/exiftags
		media-sound/picard
		media-video/vlc

		abi_x86_32? (
			app-emulation/wine
			app-emulation/winetricks
		)
	)
"
