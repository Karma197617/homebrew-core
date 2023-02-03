class Toot < Formula
  include Language::Python::Virtualenv

  desc "Mastodon CLI & TUI"
  homepage "https://toot.readthedocs.io/en/latest/index.html"
  url "https://files.pythonhosted.org/packages/31/17/a5b0352ecb8ad8177377e08bd324fad11e9e94e882c8ade375b08704507e/toot-0.34.0.tar.gz"
  sha256 "619c861e50950746673b107665997e325998276585c19a6dd42b86e1054328ce"
  license "GPL-3.0-only"
  head "https://github.com/ihabunek/toot.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9f0de5d75682a3c28ffdd6eb2599ac7ddc2933741ed243b87544d68e647750d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6a58ab22ae0f2eb2c8310e156ba8a1148e4d9f8feee24704a263e62595a2e6da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "583c804bf85e5b82c467c4ef42c1714af73b56057322246d76886387dfd2fefd"
    sha256 cellar: :any_skip_relocation, ventura:        "5df468660735054c3c11b744c870d8bd239c69e142016c2373931b7211a474e9"
    sha256 cellar: :any_skip_relocation, monterey:       "d9a73566d8ccc8cad636871716f48f9429b28fc65db7c6013818b9e8acec6642"
    sha256 cellar: :any_skip_relocation, big_sur:        "b805c2775ac4b7f408d98f59d2ebd2868a76b0419a69fd47d0e5d3a8db81c0b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79878a4b5e8c336d68fcf86e178abb1f0540186b1f0a6df830a5c5b80fd7e905"
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
    url "https://files.pythonhosted.org/packages/f3/03/bac179d539362319b4779a00764e95f7542f4920084163db6b0fd4742d38/soupsieve-2.3.2.post1.tar.gz"
    sha256 "fc53893b3da2c33de295667a0e19f078c14bf86544af307354de5fcf12a3f30d"
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
