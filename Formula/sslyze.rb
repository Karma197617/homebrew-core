class Sslyze < Formula
  include Language::Python::Virtualenv

  desc "SSL scanner"
  homepage "https://github.com/nabla-c0d3/sslyze"
  license "AGPL-3.0-only"

  stable do
    url "https://files.pythonhosted.org/packages/6d/88/78873e6c157ba91a3427ca319f9f82dad708d2531908d90e6bb7f0840b35/sslyze-5.1.2.tar.gz"
    sha256 "2ca25629f038010134d62a65627c91b0041cba836533947989176ad97c5b4285"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl/archive/5.0.0.tar.gz"
      sha256 "b1529de53e1017a4b69ad656bcef762633aec54c86c9ec016879d657bf463297"

      # type fix patch, remove in next release
      patch do
        url "https://github.com/nabla-c0d3/nassl/commit/377a85b32d6914ddba3913389f0a5a3cfbb9f20c.patch?full_index=1"
        sha256 "c225f9cad6a2bcd4d5e8acbce64ea77cad5408644d53036a65ba8deb43f78a37"
      end
      # patch to support arm builds, remove in next release
      patch do
        url "https://github.com/nabla-c0d3/nassl/commit/95f466aff36ef553429df2e95a974b3281df7709.patch?full_index=1"
        sha256 "47af75c41d028ab777781f0f3942570c221e88fc607cd476846346b6b257838f"
      end
    end
  end

  bottle do
    sha256 cellar: :any,                 ventura:      "9e3ce117c8b58e6a5d8b2fad1e3c7f70afc55999603ac5c21e406cfcc7074b67"
    sha256 cellar: :any,                 monterey:     "3cae04cb9e8ed1bee11dd14c64c510713fba8886088c18b7f83fd662c3dbfddc"
    sha256 cellar: :any,                 big_sur:      "9f3e2384c4fcb9c303e875c213bb15cf24a82d1e624443020f725183be704567"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "dcb74982224beda452dabf47c8036db69e398255d5c3116fba1711e043cea53b"
  end

  head do
    url "https://github.com/nabla-c0d3/sslyze.git", branch: "release"

    resource "nassl" do
      url "https://github.com/nabla-c0d3/nassl.git", branch: "release"
    end
  end

  depends_on "pyinvoke" => :build
  depends_on "rust" => :build # for cryptography
  depends_on "openssl@1.1"
  depends_on "pycparser"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"

  uses_from_macos "libffi", since: :catalina

  resource "cffi" do
    url "https://files.pythonhosted.org/packages/2b/a8/050ab4f0c3d4c1b8aaa805f70e26e84d0e27004907c5b8ecc1d31815f92a/cffi-1.15.1.tar.gz"
    sha256 "d400bfb9a37b1351253cb402671cea7e89bdecc294e8016a707f6d1d8ac934f9"
  end

  resource "cryptography" do
    url "https://files.pythonhosted.org/packages/fa/f3/f4b8c175ea9a1de650b0085858059050b7953a93d66c97ed89b93b232996/cryptography-39.0.2.tar.gz"
    sha256 "bc5b871e977c8ee5a1bbc42fa8d19bcc08baf0c51cbf1586b0e87a2694dde42f"
  end

  resource "pydantic" do
    url "https://files.pythonhosted.org/packages/8b/87/200171b36005368bc4c114f01cb9e8ae2a3f3325a47da8c710cc58cfd00c/pydantic-1.10.6.tar.gz"
    sha256 "cf95adb0d1671fc38d8c43dd921ad5814a735e7d9b4d9e437c088002863854fd"
  end

  resource "pyOpenSSL" do
    url "https://files.pythonhosted.org/packages/af/6e/0706d5e0eac08fcff586366f5198c9bf0a8b46f0f45b1858324e0d94c295/pyOpenSSL-23.0.0.tar.gz"
    sha256 "c1cc5f86bcacefc84dada7d31175cae1b1518d5f60d3d0bb595a67822a868a6f"
  end

  resource "tls-parser" do
    url "https://files.pythonhosted.org/packages/12/fc/282d5dd9e90d3263e759b0dfddd63f8e69760617a56b49ea4882f40a5fc5/tls_parser-2.0.0.tar.gz"
    sha256 "3beccf892b0b18f55f7a9a48e3defecd1abe4674001348104823ff42f4cbc06b"
  end

  def install
    venv = virtualenv_create(libexec, "python3.11")
    venv.pip_install resources.reject { |r| r.name == "nassl" }

    ENV.prepend_path "PATH", libexec/"bin"
    resource("nassl").stage do
      system "invoke", "build.all"
      venv.pip_install Pathname.pwd
    end

    venv.pip_install_and_link buildpath
  end

  test do
    assert_match "SCANS COMPLETED", shell_output("#{bin}/sslyze --mozilla_config=old google.com")
    refute_match("exception", shell_output("#{bin}/sslyze --certinfo letsencrypt.org"))
  end
end
