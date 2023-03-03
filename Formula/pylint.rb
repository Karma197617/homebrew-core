class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/56/5c/6bdcf113646b1dc0459d48e693932e1156376341b74a43ff0a4f79623710/pylint-2.16.3.tar.gz"
  sha256 "0decdf8dfe30298cd9f8d82e9a1542da464db47da60e03641631086671a03621"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c1a517308e8c6332198a08d2a5e05f8f7cf65358e5b39879820926fddef18f6e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ae76a128a10b452970015ceeb252ab413fad8564a549085bf86dec7ecfe48d62"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b13ac0f635c8cd89e91a897c1960d40708ffeb4bb4f64db108162e3ea2303bb7"
    sha256 cellar: :any_skip_relocation, ventura:        "350d54e4f51839d7bd2d87478bb45444a5f2f49b42b145718227853d8495aabb"
    sha256 cellar: :any_skip_relocation, monterey:       "77b111a1b0b6ce399f6bd8b7c0d032d873d5082a185dacd27193fcc7373891a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "afe061e1a5cfce983d9633e756ee2e3b6c56ef00224a8eb5f824681db7963d24"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bfb6a16a8cbbe7e5fb0f7809e058d3e39e2a30e3b137497985505db8e493ef63"
  end

  depends_on "isort"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/15/e5/7dea50225cd8b44f1488ae83a243467fe6d2a3c4f611d865085b4bba67e5/astroid-2.14.2.tar.gz"
    sha256 "a3cf9f02c53dd259144a7e8f3ccd75d67c9a8c716ef183e0c1f291bc5d7bb3cf"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/20/c0/8bab72a73607d186edad50d0168ca85bd2743cfc55560c9d721a94654b20/lazy-object-proxy-1.9.0.tar.gz"
    sha256 "659fb5809fa4629b8a1ac5106f669cfc7bef26fbb389dda53b3e010d1ac4ebae"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/8f/5f/01180534cebac14f3a792bf2f74fc99d34531c950c308fdebd9721e85550/platformdirs-3.1.0.tar.gz"
    sha256 "accc3665857288317f32c7bebb5a8e482ba717b474f3fc1d18ca7f9214be0cef"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/f8/7d/73e4e3cdb2c780e13f9d87dc10488d7566d8fd77f8d68f0e416bfbd144c7/wrapt-1.15.0.tar.gz"
    sha256 "d06730c6aed78cee4126234cf2d071e01b44b915e725a6cb439a879ec9754a3a"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    isort = Formula["isort"].opt_libexec
    (libexec/site_packages/"homebrew-isort.pth").write isort/site_packages
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
