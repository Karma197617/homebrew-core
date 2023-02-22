class Ptpython < Formula
  include Language::Python::Virtualenv

  desc "Advanced Python REPL"
  homepage "https://github.com/prompt-toolkit/ptpython"
  url "https://files.pythonhosted.org/packages/87/82/59e1ca28959b6350a62d90bbb7d19019b3e50fa01a5828936b300d2b46e1/ptpython-3.0.23.tar.gz"
  sha256 "9fc9bec2cc51bc4000c1224d8c56241ce8a406b3d49ec8dc266f78cd3cd04ba4"
  license "BSD-3-Clause"
  head "https://github.com/prompt-toolkit/ptpython.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8119a9151bf965172dab4c79593e20d6349530ab7af5c70f044ee9f3fcde1320"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "04d8f2f4fcc40c3e8f9270dffa586c87e1e92f8362efcc1fd2ca67b78251e3b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bb39b8ee66418c86e8ddeeca0a9ca852f0ee58b29f79045c2aff398728ea1ce4"
    sha256 cellar: :any_skip_relocation, ventura:        "7d09ad6c3aa4fcc54b8c5af0853e426260880659cc12610dc1227d77977ea721"
    sha256 cellar: :any_skip_relocation, monterey:       "aadb58206b8587d106b9ea36cd3b1a68f8be4ec029123ca675eb7a4ff3a0d972"
    sha256 cellar: :any_skip_relocation, big_sur:        "abf083f54beb1d98083981115e83ba826e8a9e73992889ce29769e11dcd6ffbe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89462b8c6a3c93543f16fb70e8753ae02788d27e5700343ebed89201450b9931"
  end

  depends_on "pygments"
  depends_on "python@3.11"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

  resource "jedi" do
    url "https://files.pythonhosted.org/packages/15/02/afd43c5066de05f6b3188f3aa74136a3289e6c30e7a45f351546cab0928c/jedi-0.18.2.tar.gz"
    sha256 "bae794c30d07f6d910d32a7048af09b5a39ed740918da923c6b780790ebac612"
  end

  resource "parso" do
    url "https://files.pythonhosted.org/packages/a2/0e/41f0cca4b85a6ea74d66d2226a7cda8e41206a624f5b330b958ef48e2e52/parso-0.8.3.tar.gz"
    sha256 "8c07be290bb59f03588915921e29e8a50002acaf2cdc5fa0e0114f91709fafa0"
  end

  resource "prompt-toolkit" do
    url "https://files.pythonhosted.org/packages/20/58/bbc8510ed1774ea2879b9996d2783d461c3c612904e230ff6954ce23c694/prompt_toolkit-3.0.37.tar.gz"
    sha256 "d5d73d4b5eb1a92ba884a88962b157f49b71e06c4348b417dd622b25cdd3800b"
  end

  resource "wcwidth" do
    url "https://files.pythonhosted.org/packages/5e/5f/1e4bd82a9cc1f17b2c2361a2d876d4c38973a997003ba5eb400e8a932b6c/wcwidth-0.2.6.tar.gz"
    sha256 "a5220780a404dbe3353789870978e472cfe477761f06ee55077256e509b156d0"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write "print(2+2)\n"
    assert_equal "4", shell_output("#{bin}/ptpython test.py").chomp
  end
end
