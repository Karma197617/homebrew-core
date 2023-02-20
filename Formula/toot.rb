class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https://toot.readthedocs.io/en/latest/index.html"
  url "https://files.pythonhosted.org/packages/43/b3/4d31016f6a30d3c1720d6e5af6f02833d787e3912c82a6ea5e5002f1f5a4/toot-0.34.1.tar.gz"
  sha256 "e44feff7c924111f42e0f49f93b4b9a306bc9a3c5531d0271d8e1555df5871ba"
  license "GPL-3.0-only"
  head "https://github.com/ihabunek/toot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce9aa9ce775cb4fbaef53512c44c2ee366650e56161b41e944f1d13d303db0eb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d8eac9b9f89e2304c4256f61843db0a47b145f311f8efead6ef5f9f2518edb45"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d4bd0de1ab82434f25c65d1e2176398a42af40e620af13c6a8d9c027d7444981"
    sha256 cellar: :any_skip_relocation, ventura:        "f027d3d6b925f17ecbb2773bd68bbca4b498c42b22cb57cf13316e74b7b33db5"
    sha256 cellar: :any_skip_relocation, monterey:       "29ce594d1916854c85d65b9582a1dd62b2497ed60cb1c479f1a36b421165d9a0"
    sha256 cellar: :any_skip_relocation, big_sur:        "88f48cc94c30bc4527bd35b90619c4b2b21581c6caf88fc95e7f073ee78eff91"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2df8cd5bc39309af15ed3a3826d492d13e0565bf317f9131430bd7f64214e6f1"
  end

  depends_on "python@3.11"

  resource "beautifulsoup4" do
    url "https://files.pythonhosted.org/packages/75/f8/de84282681c5a8307f3fff67b64641627b2652752d49d9222b77400d02b8/beautifulsoup4-4.11.2.tar.gz"
    sha256 "bc4bdda6717de5a2987436fb8d72f45dc90dd856bdfd512a1314ce90349a0106"
  end

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "soupsieve" do
    url "https://files.pythonhosted.org/packages/1b/cb/34933ebdd6bf6a77daaa0bd04318d61591452eb90ecca4def947e3cb2165/soupsieve-2.4.tar.gz"
    sha256 "e28dba9ca6c7c00173e34e4ba57448f0688bb681b7c5e8bf4971daafc093d69a"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  resource "urwid" do
    url "https://files.pythonhosted.org/packages/94/3f/e3010f4a11c08a5690540f7ebd0b0d251cc8a456895b7e49be201f73540c/urwid-2.1.2.tar.gz"
    sha256 "588bee9c1cb208d0906a9f73c613d2bd32c3ed3702012f51efe318a3f2127eae"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/toot")
    assert_match "You are not logged in to any accounts", shell_output("#{bin}/toot auth")
  end
end
