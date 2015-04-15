# Copyright 1999-2015 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5
inherit eutils git-2

DESCRIPTION="Unsigned and other extra integer types for PostgreSQL"
HOMEPAGE="https://github.com/petere/pguint"
SRC_URL=""
EGIT_REPO_URI="https://github.com/petere/pguint.git"
EGIT_BRANCH="master"

SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=">=dev-db/postgresql-9.0:*"

RDEPEND="${DEPEND}"

src_prepare() {
	for pgslot in $(eselect --brief postgresql list); do
		mkdir -p "${WORKDIR}/${pgslot}"
		cp -R "${S}" "${WORKDIR}/${pgslot}"
	done
}

src_configure() {
	:
}

src_compile() {
	for pgslot in $(eselect --brief postgresql list); do
		cd "${WORKDIR}/${pgslot}/${P}"
		PG_CONFIG="pg_config${pgslot//.}" emake
	done
}

src_install() {
	for pgslot in $(eselect --brief postgresql list); do
		cd "${WORKDIR}/${pgslot}/${P}"
		PG_CONFIG="pg_config${pgslot//.}" emake DESTDIR="${D}" install
	done
}
