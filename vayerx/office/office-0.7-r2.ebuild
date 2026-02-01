# Copyright 2025 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="Office staff meta"
HOMEPAGE="https://github.com/vayerx/vayerx-gentoo"
SRC_URI=""

LICENSE="GPL-3"
KEYWORDS="~amd64"
SLOT="0"
IUSE="abi_x86_32 burn +excessive gtk kde mate +rich"

PDEPEND="
	burn? (
		app-cdr/bin2iso
		app-cdr/iat
		app-cdr/nrg2iso
		app-cdr/cuetools

		kde? (
			kde-apps/k3b
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
	!mate? (
		x11-themes/adwaita-icon-theme
		x11-themes/gnome-icon-theme-extras
		x11-themes/gnome-icon-theme-symbolic
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
		app-text/djview
		media-gfx/exiv2
		media-sound/picard
		media-video/vlc

		abi_x86_32? (
			virtual/wine
		)
	)
	!rich? (
		app-text/mupdf
	)
"
