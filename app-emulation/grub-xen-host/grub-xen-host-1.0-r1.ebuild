# Copyright 1999-2021 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7

DESCRIPTION="Grub2 built as a PV grub per the Xen PV Boot Protocol"
HOMEPAGE="https://blog.xenproject.org/2015/01/07/using-grub-2-as-a-bootloader-for-xen-pv-guests/"
SRC_URI=""

LICENSE="BSD-2"
SLOT="0"
KEYWORDS="amd64"
IUSE="pvh"

DEPEND="sys-boot/grub:2=[grub_platforms_xen]
	pvh? ( >=sys-boot/grub-2.04:2=[grub_platforms_xen-pvh] )
	app-emulation/xen-tools:="
RDEPEND="${DEPEND}"

S="${WORKDIR}"

RESTRICT="binchecks strip test"

src_configure() {
	:
}

src_compile() {
	cat > "${S}/grub-bootstrap.cfg" <<- EOF || die
		normal (memdisk)/grub.cfg
	EOF

	cat > "${S}/grub.cfg" <<- EOF || die
		if search -s -f /boot/xen/pvboot-x86_64.elf ; then
			echo "Chainloading (${root})/boot/xen/pvboot-x86_64.elf"
			multiboot "/boot/xen/pvboot-x86_64.elf"
			boot
		fi

		if search -s -f /xen/pvboot-x86_64.elf ; then
			echo "Chainloading (${root})/xen/pvboot-x86_64.elf"
			multiboot "/xen/pvboot-x86_64.elf"
			boot
		fi

		if search -s -f /boot/grub/grub.cfg ; then
			echo "Reading (${root})/boot/grub/grub.cfg"
			configfile /boot/grub/grub.cfg
		fi

		if search -s -f /grub/grub.cfg ; then
			echo "Reading (${root})/grub/grub.cfg"
			configfile /grub/grub.cfg
		fi
	EOF

	tar cf memdisk.tar grub.cfg || die "failed to tar"

	local grub_mkimage=grub-mkimage
	if type grub2-mkimage &> /dev/null; then
		grub_mkimage=grub2-mkimage
	fi

	local args=(
		"${grub_mkimage}"
		-O x86_64-xen
		-c grub-bootstrap.cfg
		-m memdisk.tar
		-o grub-x86_64-xen.bin
		/usr/lib/grub/x86_64-xen/*.mod
	)

	echo "${args[@]}"
	"${args[@]}" || die "failed to grub-mkimage"

	if use pvh; then
		local args=(
			"${grub_mkimage}"
			-O i386-xen_pvh
			-c grub-bootstrap.cfg
			-m memdisk.tar
			-o grub-i386-xen_pvh.bin
			/usr/lib/grub/i386-xen_pvh/*.mod
		)

		echo "${args[@]}"
		"${args[@]}" || die "failed to grub-mkimage"
	fi

}

src_install() {
	exeinto /usr/libexec/xen/bin
	doexe grub-x86_64-xen.bin
	if use pvh; then
		doexe grub-i386-xen_pvh.bin
	fi
}
