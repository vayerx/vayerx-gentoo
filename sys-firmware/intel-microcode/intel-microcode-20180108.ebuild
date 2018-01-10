# Copyright 1999-2018 Gentoo Foundation
# Distributed under the terms of the GNU General Public License v2

EAPI="6"

inherit toolchain-funcs

# Find updates by searching and clicking the first link (hopefully it's the one):
# http://www.intel.com/content/www/us/en/search.html?keyword=Processor+Microcode+Data+File

NUM="27431"
DESCRIPTION="Intel IA32/IA64 microcode update data"
HOMEPAGE="http://inertiawar.com/microcode/ https://downloadcenter.intel.com/download/${NUM}/Linux-Processor-Microcode-Data-File"
SRC_URI="http://downloadmirror.intel.com/${NUM}/eng/microcode-${PV}.tgz"

LICENSE="intel-ucode"
SLOT="0"
KEYWORDS="-* amd64 x86"
IUSE="initramfs +split-ucode"
REQUIRED_USE="|| ( initramfs split-ucode )"

DEPEND="initramfs? ( sys-apps/iucode_tool )"
RDEPEND="!<sys-apps/microcode-ctl-1.17-r2" #268586

S=${WORKDIR}

src_compile() {
	if use initramfs ; then
		iucode_tool --write-earlyfw=microcode.cpio intel-ucode/ || die
	fi
}

src_install() {
	insinto /lib/firmware
	use initramfs && doins microcode.cpio
	use split-ucode && doins -r intel-ucode
}
