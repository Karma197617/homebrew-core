class Glances < Formula
  include Language::Python::Virtualenv

  desc "Alternative to top/htop"
  homepage "https://nicolargo.github.io/glances/"
  url "https://files.pythonhosted.org/packages/02/24/7901220f0cad117718265410f05e84e60e50cd049da3d11e9d5dd9a18f8a/Glances-3.3.1.tar.gz"
  sha256 "aa834e0ad25c12193c6dba37a107efa76af1c77394ace324f610e7b20491f0c7"
  license "LGPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00c117dbdafadc7b85c7ff62d7ebc0ea85e6034b92e8000643d4f1ed70789f93"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e1e9661ad43f4ea3be24818e10ea850d77380eb1a7080121617143db6797ddeb"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f060745e511eafc304a4f945ef50fc70693790bda87f77385084863279d79c0f"
    sha256 cellar: :any_skip_relocation, ventura:        "c99b8aa453b7fe043747a71f6d132f5198837ea894eb4c8c088f3bec343e07a3"
    sha256 cellar: :any_skip_relocation, monterey:       "a894e09c7e3d3e6d63e36874612b9f6bc90b74f16eaa6b3ee14c3af755630310"
    sha256 cellar: :any_skip_relocation, big_sur:        "c0b1c59505c292e21785814c609f1076562b6dcd7e8e93279541a306fb049364"
    sha256 cellar: :any_skip_relocation, catalina:       "6774d0e64a60bb48dda5f505dc9583d6a59cc21907365f6a9511c51fa61c06e1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "925d6976ff5cffabd2f573a530870628e3d01f9dc27963205bed584726b7c7c1"
  end

  depends_on "python@3.11"

  resource "defusedxml" do
    url "https://files.pythonhosted.org/packages/0f/d5/c66da9b79e5bdb124974bfe172b4daf3c984ebd9c2a06e2b8a4dc7331c72/defusedxml-0.7.1.tar.gz"
    sha256 "1bb3032db185915b62d7c6209c5a8792be6a32ab2fedacc84e01b52c51aa3e69"
  end

  resource "future" do
    url "https://files.pythonhosted.org/packages/8f/2e/cf6accf7415237d6faeeebdc7832023c90e0282aa16fd3263db0eb4715ec/future-0.18.3.tar.gz"
    sha256 "34a17436ed1e96697a86f9de3d15a3b0be01d8bc8de9c1dffd59fb8234ed5307"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
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
