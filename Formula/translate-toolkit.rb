class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/5f/24/11587aa98f03fc076f205714245c630d1bab1e7f83e911c32827b9461d8e/translate-toolkit-3.8.4.tar.gz"
  sha256 "f5ce4f301be38c1f388bf6e50beadb3d0219185105d1a5d023a982d66801f55e"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "011b35c48cf1dd89795bc8ae2964ac906f76bf8e22fbd764c39ec4136cce9812"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "afd8cc016a004e1706bbf3e7aaeadca94efb3d1a855070f70cca64a90dcf042d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a1735e1723cc9682f097acb80681c27146ea00393c33021e813cb1e89168e8f5"
    sha256 cellar: :any_skip_relocation, ventura:        "4f73f55a96411846630211f500627269b39abd662d964e9213e3ba132109eee1"
    sha256 cellar: :any_skip_relocation, monterey:       "fae668cccf39db59b12afb2ae9a62c0ec418e43a441131d06c9b1214b7893d98"
    sha256 cellar: :any_skip_relocation, big_sur:        "b0614b2c00453c259a0111e0b6b7896bc840730c7e0b8be9f0789e0fb9458263"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e3e0329f82568cd018f98324e63ca2dca80e7b96b4ba7bc6522b3958da41f80"
  end

  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
