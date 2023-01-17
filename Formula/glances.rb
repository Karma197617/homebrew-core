class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/84/79/538d602245f967f96f22c80bebae8314bde6557d5637232880168a77f06d/Glances-3.3.1.1.tar.gz"
  sha256 "30a292210cbfbf2ae77ca2016561c0358cc4a3f041f1b0d4bcf6f62bf516299a"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "455d2780b07e94f08fdf3fc14b7559cd2a3c2247ddfea8996249365259763df4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "26e9541c35731d9aa7a4ec508534ade46cbfb349193c03849f17d504be6b2be1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f9d77677f7a2ca3deda74f4de658bd239d0da8798e9d973c628eb5713ec5dab4"
    sha256 cellar: :any_skip_relocation, ventura:        "389b56b3b4cfc5c6205b0db132401b18e4674de283925fd349d5966e651dd422"
    sha256 cellar: :any_skip_relocation, monterey:       "c6bb47cbbc958c51465cc6d386a0827746340c5a0d80f3b0b7ba62310d68efb1"
    sha256 cellar: :any_skip_relocation, big_sur:        "9f49ffe6ada6c44f237d51ec0d8253d94cbd1d70d368a7a0f372786589fcaec7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66e5a5b328d7102fe9413ce8f0957fc96c2f75699dc26815f0ac72df5364b9a2"
  end

  depends_on "python@3.11"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "ujson" do
    url "https://files.pythonhosted.org/packages/43/1a/b0a027144aa5c8f4ea654f4afdd634578b450807bb70b9f8bad00d6f6d3c/ujson-5.7.0.tar.gz"
    sha256 "e788e5d5dcae8f6118ac9b45d0b891a0d55f7ac480eddcb7f07263f2bcf37b23"
  end

  def install
    virtualenv_install_with_resources
    prefix.install libexec/"share"
  end

  test do
    read, write = IO.pipe
    pid = fork do
      exec bin/"glances", "-q", "--export", "csv", "--export-csv-file", "/dev/stdout", out: write
    end
    header = read.gets
    assert_match "timestamp", header
  ensure
    Process.kill("TERM", pid)
  end
end
