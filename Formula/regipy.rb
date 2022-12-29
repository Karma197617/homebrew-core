class Regipy < Formula
  include Language::Python::Virtualenv

  desc "Offline registry hive parsing tool"
  homepage "https://github.com/mkorman90/regipy"
  url "https://files.pythonhosted.org/packages/2a/33/5f58f2deed2b73b2bd0f0f6cd9b68f213b41c06fefca12db39c06035fc1a/regipy-3.1.2.tar.gz"
  sha256 "9051afcf6f90e4c5635b833812a398a5a682fcb0944bb2f372879542f15effae"
  license "MIT"
  head "https://github.com/mkorman90/regipy.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbfb8724d5721d1bb81bdb1e297dcee1f6a603720646eb99ebd83da12224c873"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c7de87cf658e974f95c945be83d4e1219124bbd2f0f2e4579a5342ec8874a260"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56cd72cec9d0b3b5f420578100ebcafb525d8104ae79306697a2f5198a34e992"
    sha256 cellar: :any_skip_relocation, ventura:        "a3c3d28ded44cdf7be27c61398be44bbd4c408a9b71b5c572cb23a759b9ccaaf"
    sha256 cellar: :any_skip_relocation, monterey:       "939220ac2c3ee667d2140f3afa3cf36d747be731262d408b1329cc96f554fe49"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6e4b6f208fd5d87db01c91d3793a444f5bf681e3b1ad4bfb8bf6ef11a3e7e7b"
    sha256 cellar: :any_skip_relocation, catalina:       "89826d2878c0d9096d3f426aec0e6a117581e43ae7857cc8d7199adb9dff3e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "da777e062e07a686bd6fb0ba1cafbb19b88881b3cb762bcc0a7abf63c8154232"
  end

  depends_on "python-tabulate"
  depends_on "python@3.11"

  resource "attrs" do
    url "https://files.pythonhosted.org/packages/21/31/3f468da74c7de4fcf9b25591e682856389b3400b4b62f201e65f15ea3e07/attrs-22.2.0.tar.gz"
    sha256 "c9227bfc2f01993c03f68db37d1d15c9690188323c067c641f1a35ca58185f99"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "construct" do
    url "https://files.pythonhosted.org/packages/e0/b7/a4a032e94bcfdff481f2e6fecd472794d9da09f474a2185ed33b2c7cad64/construct-2.10.68.tar.gz"
    sha256 "7b2a3fd8e5f597a5aa1d614c3bd516fa065db01704c72a1efaaeec6ef23d8b45"
  end

  resource "inflection" do
    url "https://files.pythonhosted.org/packages/e1/7e/691d061b7329bc8d54edbf0ec22fbfb2afe61facb681f9aaa9bff7a27d04/inflection-0.5.1.tar.gz"
    sha256 "1a29730d366e996aaacffb2f1f1cb9593dc38e2ddd30c91250c6dde09ea9b417"
  end

  resource "pytz" do
    url "https://files.pythonhosted.org/packages/6d/37/54f2d7c147e42dc85ffbc6910862bb4f141fb3fc14d9a88efaa1a76c7df2/pytz-2022.7.tar.gz"
    sha256 "7ccfae7b4b2c067464a6733c6261673fdb8fd1be905460396b97a073e9fa683a"
  end

  resource "test_hive" do
    url "https://raw.githubusercontent.com/mkorman90/regipy/71acd6a65bdee11ff776dbd44870adad4632404c/regipy_tests/data/SYSTEM.xz"
    sha256 "b1582ab413f089e746da0528c2394f077d6f53dd4e68b877ffb2667bd027b0b0"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources.reject { |r| r.name == "test_hive" }
    venv.pip_install_and_link buildpath
  end

  test do
    resource("test_hive").stage do
      system bin/"registry-plugins-run", "-p", "computer_name", "-o", "out.json", "SYSTEM"
      h = JSON.parse(File.read("out.json"))
      assert_equal h["computer_name"][0]["name"], "WKS-WIN732BITA"
      assert_equal h["computer_name"][1]["name"], "WIN-V5T3CSP8U4H"
    end
  end
end
