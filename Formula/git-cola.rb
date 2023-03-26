class GitCola < Formula
  include Language::Python::Virtualenv

  desc "Highly caffeinated git GUI"
  homepage "https://git-cola.github.io/"
  url "https://files.pythonhosted.org/packages/38/e0/b0d4e6a7c048ee8490d21a3c942bdffd6cee3e71dd5be8f33c944312c8a2/git-cola-4.2.0.tar.gz"
  sha256 "76be2e0fae4e64612ab30adff7f53bc687ab92fb3498e90f54c0301f2135a5c0"
  license "GPL-2.0-or-later"
  head "https://github.com/git-cola/git-cola.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00b59e32b2e4d10c6017593d6e90c14e4c832cd94811d3fc15ee176c2789d11b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45f775fc5152cf58ccbf1d41d4dc1245a8ce9536105abac21f27a815e04376b4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ddbcd2e2713e5ce723f8e59a7521df4044e35f0879776575e995b96cd879aa4d"
    sha256 cellar: :any_skip_relocation, ventura:        "ca4a71ed10ef7ae4ebec5d23e680f0f72da5db81085ba03b53c82881034164c8"
    sha256 cellar: :any_skip_relocation, monterey:       "04f0e2341bb37e8a6379d7b4917cc5b64af25e8e4123909235f1dc18215118e6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0222466f193f97369115a36b860dd96d911dc8bfb2c08b2923e52a565472373d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a591321e52c5a41e4154cced1c9dfa8d31eab69dd52cbdaa18f00708ca44c05e"
  end

  depends_on "pyqt@5"
  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pyparsing" do
    url "https://files.pythonhosted.org/packages/71/22/207523d16464c40a0310d2d4d8926daffa00ac1f5b1576170a32db749636/pyparsing-3.0.9.tar.gz"
    sha256 "2b020ecf7d21b687f219b71ecad3631f644a47f01403fa1d1036b0c6416d70fb"
  end

  resource "QtPy" do
    url "https://files.pythonhosted.org/packages/b0/96/4f3be023cee0261b1f6cd5d2f6c2a5abea8d8022fc66027da8792373a57e/QtPy-2.3.0.tar.gz"
    sha256 "0603c9c83ccc035a4717a12908bf6bc6cb22509827ea2ec0e94c2da7c9ed57c5"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"git-cola", "--version"
  end
end
