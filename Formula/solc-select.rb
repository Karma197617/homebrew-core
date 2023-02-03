class SolcSelect < Formula
  include Language::Python::Virtualenv

  desc "Manage multiple Solidity compiler versions"
  homepage "https://github.com/crytic/solc-select"
  url "https://files.pythonhosted.org/packages/47/75/9355ad75576d94b59383b62d70e403868512639c3fe3290594cdf0a53dab/solc-select-1.0.3.tar.gz"
  sha256 "f39d08035355bd0e0a887e4a1088ea10a15dd64e4408cc7fcd72d913b46fc799"
  license "AGPL-3.0-only"
  head "https://github.com/crytic/solc-select.git", branch: "dev"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a55f962a9c03772c6a1d4edee6ce5a2352d66a3a01412c300293e18f6d2bd79d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "bab938bd7e4a232378ffea6255dd48234eebec4465d4330198c8a098aba6693a"
    sha256 cellar: :any_skip_relocation, ventura:        "9aabde46ca59499ae107856ea8e33c0ef806aaa58da13772d1b7eba6c6dd19a7"
    sha256 cellar: :any_skip_relocation, monterey:       "f539d2a03bd4ac11ff4ca3bd4decba2f6f9bd4b11b6a2e150c52663aaffb9486"
    sha256 cellar: :any_skip_relocation, big_sur:        "9878f267a773134af1a671cb3fdaa54accf767f32eddf68efc691905b8b46c98"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3ceac03eb7e1ab4d3a4b1727b43d98290dfe68ffbffecf87b2489b43ee4fe3fb"
  end

  depends_on "python@3.11"

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "pycryptodome" do
    url "https://files.pythonhosted.org/packages/b8/2e/cf9cfd1ae6429381d3d9c14c8df79d91ae163929972f245a76058ea9d37d/pycryptodome-3.17.tar.gz"
    sha256 "bce2e2d8e82fcf972005652371a3e8731956a0c1fbb719cc897943b3695ad91b"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system bin/"solc-select", "install", "0.5.7"
    system bin/"solc-select", "install", "0.8.0"
    system bin/"solc-select", "use", "0.5.7"

    assert_match("0.5.7", shell_output("#{bin}/solc --version"))
    with_env(SOLC_VERSION: "0.8.0") do
      assert_match("0.8.0", shell_output("#{bin}/solc --version"))
    end
  end
end
