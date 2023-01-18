class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/34/12/c1d0b4d98d9214dcbe753c7f534ffcfad604553ec8ce6ceee8c82c77a4c3/translate-toolkit-3.8.3.tar.gz"
  sha256 "aecc92b64617d20c4115979993eb2a96c2a4a080acbda0ebf98c8de72bd2e97e"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "185a0751dd8476565f179c9f65d62565fa44c8780a217c7ba297a4097670404d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2b6b9a0e3ec4bd206ad2105331bd22c574268bc6a48de6bd397f8959fff727a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6625b7c66d015f1a2b3ede96b2ce0e23e7cb83665f972f7f3f542a47781d2433"
    sha256 cellar: :any_skip_relocation, ventura:        "a7fce9147df947c26252fc022ad0c3020c05b4b1cfdd01cd186dee8ac415fac4"
    sha256 cellar: :any_skip_relocation, monterey:       "22dda8a88077eea4c98e0ffb860d85519157481b27bd84404c8edd5efd2c9d97"
    sha256 cellar: :any_skip_relocation, big_sur:        "872c7d6187ade63ba44d4e24bf52fa9dba35efb523c21fef162d547d115095f2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4297dab124c8a6af1116fb1189e6be722edc72e117acd721b44847d34741a32"
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
