# Copyright 1999-2022 Gentoo Authors
# Distributed under the terms of the GNU General Public License v2

EAPI=7
USE_RUBY="ruby25 ruby26 ruby27"

RUBY_FAKEGEM_EXTRADOC="CHANGELOG README.md TODO.md"

RUBY_FAKEGEM_EXTRAINSTALL="schemas"

RUBY_FAKEGEM_GEMSPEC="json_schema.gemspec"

inherit ruby-fakegem

DESCRIPTION="A JSON Schema V4 and Hyperschema V4 parser and validator"
HOMEPAGE="https://github.com/brandur/json_schema"
SRC_URI="https://github.com/brandur/json_schema/archive/v${PV}.tar.gz -> ${P}.tar.gz"

LICENSE="MIT"
SLOT="0"
KEYWORDS="~amd64 ~riscv"
IUSE=""

ruby_add_bdepend "test? ( dev-ruby/ecma-re-validator )"

all_ruby_prepare() {
	sed -i -e '/bundler/I s:^:#:' Rakefile || die
	sed -i -e '/^if/,/^end/ s:^:#:' test/test_helper.rb || die
}
