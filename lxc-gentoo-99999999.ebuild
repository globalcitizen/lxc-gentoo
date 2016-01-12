# Distributed under the terms of the GNU General Public License v2
# $Header: $

EAPI=5

inherit git-2 eutils

DESCRIPTION="LXC container creation script for gentoo containers"
HOMEPAGE="https://github.com/globalcitizen/lxc-gentoo"
EGIT_REPO_URI="https://github.com/globalcitizen/lxc-gentoo.git"

LICENSE="GPL-3"
SLOT="0"
KEYWORDS="~amd64 ~ia64 ~ppc ~sparc ~x86"
IUSE=""

DEPEND="app-emulation/lxc"
RDEPEND="${DEPEND}"

src_install() {
	dobin lxc-gentoo
}
