class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/51/91/fe1940b40d25221a79150c8199c46145b0af2fc151e5051ee38d06e91b0a/translate-toolkit-3.8.2.tar.gz"
  sha256 "0ce1ca033164b07762bd3757c9dd9aae825aa743de97f465c3fa73d7d1cd8450"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2343258d785a0a99d661bd08414f31de148b31737142b78477eac2fc6de1c00e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ae1674fdbd57167d88796f5d1e92a5a0ba3c2a75e6f74abf651cc594f3d2406"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9f8f8974c054b0825b9a7c69aac7118e7e41dfe64362b533bcab32fa88a35c44"
    sha256 cellar: :any_skip_relocation, ventura:        "1831d79d68e753b50ad17a5bcfa714507eb494b359a263a317d9fead9b67fff3"
    sha256 cellar: :any_skip_relocation, monterey:       "5cd7d6181d36b78c931d0071d0d03db48ec806ce713aaa9dd0da95537be40669"
    sha256 cellar: :any_skip_relocation, big_sur:        "6c7d91aa4253af9587e8b474c6134983be05e0b91072612a1e2a26a981b45d45"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f19e0cc0853e7ed90f9c54d1e8b57ad9fd3dd1231216449706957021544ffe6b"
  end

  depends_on "python@3.11"

  uses_from_macos "libxml2"
  uses_from_macos "libxslt"

  resource "lxml" do
    url "https://files.pythonhosted.org/packages/06/5a/e11cad7b79f2cf3dd2ff8f81fa8ca667e7591d3d8451768589996b65dec1/lxml-4.9.2.tar.gz"
    sha256 "2455cfaeb7ac70338b3257f41e21f0724f4b5b0c0e7702da67ee6c3640835b67"
  end

  def install
    # Workaround to avoid creating libexec/bin/__pycache__ which gets linked to bin
    ENV["PYTHONPYCACHEPREFIX"] = buildpath/"pycache"

    virtualenv_install_with_resources
  end

  test do
    system bin/"pretranslate", "-h"
    system bin/"podebug", "-h"
  end
end
