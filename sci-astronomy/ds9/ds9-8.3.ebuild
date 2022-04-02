# Copyright 2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=8

DESCRIPTION="An image display and visualization tool for astronomical data"
HOMEPAGE="https://ds9.si.edu"
SRC_URI="https://ds9.si.edu/download/source/${PN}.${PV}.tar.gz"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64"

DEPEND="
	media-libs/fontconfig
	media-libs/freetype
	x11-libs/libX11
	x11-libs/libXScrnSaver
	x11-libs/libXext
	x11-libs/libXft
	x11-libs/libXrandr
	x11-libs/libXrender
	x11-libs/xpa
	sys-devel/automake
	sys-devel/autoconf
	sys-libs/zlib
	dev-libs/libxml2
	dev-libs/libxslt
	dev-lang/tcl
	dev-lang/tk"
RDEPEND="${DEPEND}"

S=${WORKDIR}/SAOImageDS9

src_configure() {
	cp unix/* ./
	econf
}

src_compile() {
	emake
}

inherit desktop

src_install() {
	dobin ${S}/bin/ds9
	doicon ${S}/ds9/doc/sun.gif
	make_desktop_entry /usr/bin/ds9 SAOImageDS9 /usr/share/pixmaps/sun.gif
}
