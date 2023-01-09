class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/84/c8/6d7d7910699518b5188631bcc4a0dc3c116e0b9d7bbf85183bfc9b7607aa/pylint-2.15.10.tar.gz"
  sha256 "b3dc5ef7d33858f297ac0d06cc73862f01e4f2e74025ec3eff347ce0bc60baf5"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "27f3c9c0f8b863f1a6e8c9b19dcf2ca8daef1c1dd17b5f97df69d6edb4a14b03"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33e6cdd8881ef2c2eb99e562bfef30f2705e19372941dacc3cf68f48e3beb693"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "63c710bbdd43664e661aea2f06607eb84f5085eba5037a8ea817fc7b27c50c19"
    sha256 cellar: :any_skip_relocation, ventura:        "0f760483121a48756a324530d12fe5b5f969efb943d72ef4f465d17f51bd6f1d"
    sha256 cellar: :any_skip_relocation, monterey:       "13d3712428b9c1356a63c36decfb6ee379aa5447b8ae1e6c5a82f792f317a87c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5ef313ba697fcdc49b8ac343cbca9c805917cd30d5cf05af4a8a0b84f1f5368"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3c97ad5fb2043653f63cb5ad1aa69d54ad63ef6992162203a197cbae3773486"
  end

  depends_on "isort"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/c2/49/5dd5f36b2cd2b315d45023ed4e2d6f1ba57d054ea9a1378f91f093ec57bb/astroid-2.13.2.tar.gz"
    sha256 "3bc7834720e1a24ca797fd785d77efb14f7a28ee8e635ef040b6e2d80ccb3303"
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
    url "https://files.pythonhosted.org/packages/cf/4d/198b7e6c6c2b152f4f9f4cdf975d3590e33e63f1920f2d89af7f0390e6db/platformdirs-2.6.2.tar.gz"
    sha256 "e1fea1fe471b9ff8332e229df3cb7de4f53eeea4998d3b6bfff542115e998bd2"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/e3/a7/8f4e456ef0adac43f452efc2d0e4b242ab831297f1bac60ac815d37eb9cf/typing_extensions-4.4.0.tar.gz"
    sha256 "1511434bb92bf8dd198c12b1cc812e800d4181cfcb867674e0f8279cc93087aa"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
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
