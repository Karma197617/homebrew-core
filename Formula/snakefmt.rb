class Snakefmt < Formula
  include Language::Python::Virtualenv

  desc "Snakemake code formatter"
  homepage "https://github.com/snakemake/snakefmt/"
  url "https://files.pythonhosted.org/packages/36/2e/3781ccb07a312f59e343d6a5e6586b20972a540b49a9cded917ff371bbbd/snakefmt-0.8.0.tar.gz"
  sha256 "22bbc1552164d9a1556bedf01db463515ead3b37fb2c7ae29975ab7f13f5995d"
  license "MIT"
  head "https://github.com/snakemake/snakefmt.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "24f528537b77695f070e659e33cb61b584ec61f08033ec9292af3f2ba8191a86"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "da11c1380d061cfcb1a4e6f21eb81d826637e7fd50d2d206fb8bb559a04471de"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d024e159f79b77b92ba8abc4de1083bc65deb968c832dc9616b378ec92779b61"
    sha256 cellar: :any_skip_relocation, ventura:        "6112689c7d9a1a68457f93f40cd19141ff9cf029978affd6dcb3015f251351b6"
    sha256 cellar: :any_skip_relocation, monterey:       "c4e1ec2ae7cf58e2c99e4e4bed2de3dda255df176f0d30ef8dbd0045d3eb36e5"
    sha256 cellar: :any_skip_relocation, big_sur:        "d361b04fdaca0b72427e3e0a3dfaef8cc8b618307d5b31c3122f22d77298e4fa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78edb0a5016951baa7dfb845a548793c21d13e76c825931dbfe9c886430cbf09"
  end

  depends_on "cmake" => :build
  depends_on "black"
  depends_on "python@3.11"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "rust" => :build
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  def install
    virtualenv_install_with_resources

    site_packages = Language::Python.site_packages("python3.11")
    black = Formula["black"].opt_libexec
    (libexec/site_packages/"homebrew-black.pth").write black/site_packages
  end

  test do
    test_file = testpath/"Snakefile"
    test_file.write <<~EOS
      rule testme:
          output:
               "test.out"
          shell:
               "touch {output}"
    EOS
    test_output = shell_output("#{bin}/snakefmt --check #{test_file} 2>&1", 1)
    assert_match "[INFO] 1 file(s) would be changed 😬", test_output

    assert_match "snakefmt, version #{version}",
      shell_output("#{bin}/snakefmt --version")
  end
end
