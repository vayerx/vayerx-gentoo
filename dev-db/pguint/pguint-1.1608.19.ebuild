# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI=7

EGIT_REPO_URI="https://github.com/petere/pguint.git"
EGIT_COMMIT="$(ver_cut 1).20$(ver_cut 2)$(ver_cut 3)"

inherit eutils git-r3

DESCRIPTION="Unsigned and other extra integer types for PostgreSQL"
HOMEPAGE="https://github.com/petere/pguint"
SRC_URL=""

SLOT="0"
KEYWORDS="amd64"
IUSE=""

DEPEND=">=dev-db/postgresql-9.1"

RDEPEND="${DEPEND}"

src_prepare() {
	for pgslot in $(eselect --brief postgresql list); do
		mkdir -p "${WORKDIR}/${pgslot}"
		cp -R "${S}" "${WORKDIR}/${pgslot}"
	done

	eapply_user
}

src_compile() {
	for pgslot in $(eselect --brief postgresql list); do
		cd "${WORKDIR}/${pgslot}/${P}"
		PG_CONFIG="pg_config${pgslot//.}" emake -j1
	done
}

src_install() {
	for pgslot in $(eselect --brief postgresql list); do
		cd "${WORKDIR}/${pgslot}/${P}"
		PG_CONFIG="pg_config${pgslot//.}" emake DESTDIR="${D}" install
	done
}
