class Ykman < Formula
  include Language::Python::Virtualenv

  desc "Tool for managing your YubiKey configuration"
  homepage "https://developers.yubico.com/yubikey-manager/"
  url "https://files.pythonhosted.org/packages/04/3d/f94043b6cbc0e44d0824b466840097bd3599eb46a8bd7716f6a93ddc172f/yubikey_manager-5.0.1.tar.gz"
  sha256 "89e9b99211b474e38ce6687ba1fd37fa470eefeb8c1f9d47c8189c9c5bbb036f"
  license "BSD-2-Clause"
  head "https://github.com/Yubico/yubikey-manager.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3fc62037229dc461447d747037f1ccd483db5b48c878257703535954b07f7283"
    sha256 cellar: :any,                 arm64_monterey: "cd733000ba56bd3800af24aa4b5309cccd54ca82dd955a2cbb92a413164b2ae9"
    sha256 cellar: :any,                 arm64_big_sur:  "813bde6cbe7e0251abfe8b3817bdd271d82d7e125e71678fbaa7d2b0a97d1345"
    sha256 cellar: :any,                 ventura:        "6d6e00240012a0a956a0a0322e845f0b76929f0d5cb0b33213759e22522d558a"
    sha256 cellar: :any,                 monterey:       "c71653347e5209dedc1d1ed4670f7b2549f10250b46176c6d03aac1613718f2e"
    sha256 cellar: :any,                 big_sur:        "7c09339831e8ac15337c9c413c75b94e490af4d83383e23528c5fbf6474df827"
    sha256 cellar: :any,                 catalina:       "8486be81e85b9501966c3ab9657bddeef793329b91341fb0b33f60e4fbc719ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8a3c7606b95add89c47a501c0f3c4d864834679ba0f2d8efb362b43b913b7bcb"
  end

  depends_on "rust" => :build
  depends_on "swig" => :build
  depends_on "openssl@1.1"
  depends_on "python@3.11"

  uses_from_macos "libffi"

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "pcsc-lite"
  end

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "click" do
    url "https://files.pythonhosted.org/packages/59/87/84326af34517fca8c58418d148f2403df25303e02736832403587318e9e8/click-8.1.3.tar.gz"
    sha256 "7682dc8afb30297001674575ea00d1814d808d6a36af415a82bd481d37ba7b8e"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/12/e3/c46c274cf466b24e5d44df5d5cd31a31ff23e57f074a2bb30931a8c9b01a/cryptography-39.0.0.tar.gz"
    sha256 "f964c7dcf7802d133e8dbd1565914fa0194f9d683d82411989889ecd701e8adf"
  end

  resource "fido2" do
    url "https://files.pythonhosted.org/packages/00/b9/0dfa7dec57ddec0d40a1a56ab28e6b97e31d1225787f2c80a7ab217e0ee6/fido2-1.1.0.tar.gz"
    sha256 "2b4b4e620c2100442c20678e0e951ad6d1efb3ba5ca8ebb720c4c8d543293674"
  end

  resource "importlib-metadata" do
    url "https://files.pythonhosted.org/packages/90/07/6397ad02d31bddf1841c9ad3ec30a693a3ff208e09c2ef45c9a8a5f85156/importlib_metadata-6.0.0.tar.gz"
    sha256 "e354bedeb60efa6affdcc8ae121b73544a7aa74156d047311948f6d711cd378d"
  end

  resource "jaraco.classes" do
    url "https://files.pythonhosted.org/packages/bf/02/a956c9bfd2dfe60b30c065ed8e28df7fcf72b292b861dca97e951c145ef6/jaraco.classes-3.2.3.tar.gz"
    sha256 "89559fa5c1d3c34eff6f631ad80bb21f378dbcbb35dd161fd2c6b93f5be2f98a"
  end

  resource "keyring" do
    url "https://files.pythonhosted.org/packages/55/fe/282f4c205add8e8bb3a1635cbbac59d6def2e0891b145aa553a0e40dd2d0/keyring-23.13.1.tar.gz"
    sha256 "ba2e15a9b35e21908d0aaf4e0a47acc52d6ae33444df0da2b49d41a46ef6d678"
  end

  resource "more-itertools" do
    url "https://files.pythonhosted.org/packages/13/b3/397aa9668da8b1f0c307bc474608653d46122ae0563d1d32f60e24fa0cbd/more-itertools-9.0.0.tar.gz"
    sha256 "5a6257e40878ef0520b1803990e3e22303a41b5714006c32a3fd8304b26ea1ab"
  end

  resource "pycparser" do
    url "https://files.pythonhosted.org/packages/5e/0b/95d387f5f4433cb0f53ff7ad859bd2c6051051cebbb564f139a999ab46de/pycparser-2.21.tar.gz"
    sha256 "e644fdec12f7872f86c58ff790da456218b10f863970249516d60a5eaca77206"
  end

  resource "pyscard" do
    url "https://files.pythonhosted.org/packages/07/64/62200892980cacc2968ab6e5ae6ddd345c8b96e2e2076aea9e0459fc540b/pyscard-2.0.5.tar.gz"
    sha256 "dc13e34837addbd96c07a1a919fbc1677b2b83266f530a1f79c96930db42ccde"
  end

  resource "zipp" do
    url "https://files.pythonhosted.org/packages/8e/b3/8b16a007184714f71157b1a71bbe632c5d66dd43bc8152b3c799b13881e1/zipp-3.11.0.tar.gz"
    sha256 "a7a22e05929290a67401440b39690ae6563279bced5f314609d9d03798f56766"
  end

  def install
    # Fixes: smartcard/scard/helpers.c:28:22: fatal error: winscard.h: No such file or directory
    ENV.append "CFLAGS", "-I#{Formula["pcsc-lite"].opt_include}/PCSC" if OS.linux?

    virtualenv_install_with_resources
    man1.install "man/ykman.1"

    # Click doesn't support generating completions for Bash versions older than 4.4
    generate_completions_from_executable(bin/"ykman", shells: [:fish, :zsh], shell_parameter_format: :click)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/ykman --version")
  end
end
