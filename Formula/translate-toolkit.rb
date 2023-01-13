class TranslateToolkit < Formula
  include Language::Python::Virtualenv

  desc "Toolkit for localization engineers"
  homepage "https://toolkit.translatehouse.org/"
  url "https://files.pythonhosted.org/packages/c6/23/64c026fa7f84322987cd7a139a661058fe35a5ea295984063adc0abae7f8/translate-toolkit-3.8.1.tar.gz"
  sha256 "59e32cd7527bf878dcbd78b34add880edcbbbb8d38f39e6186942238ff6c0e9a"
  license "GPL-2.0-or-later"
  head "https://github.com/translate/translate.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f017a6c32081c5827b60c84a7e4a96f63abeccc01bacaf09b6f45cdcc93eece6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "744d75fdc2ad123728e9c5d108c7b6003b190c20411df746990e34b03b38eb35"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2a0bffe3c9fe3c54d53779c6f000264880c713ee23668aa50233d5cdb0e31ffa"
    sha256 cellar: :any_skip_relocation, ventura:        "8eab96dc9fce3aafab1d69af137f031a37ebae9e0dc9f7ae7afa590996cd9272"
    sha256 cellar: :any_skip_relocation, monterey:       "b14944279707b355105454d7ffbe5ddf4d502f245237d576bf799778c9f48f6e"
    sha256 cellar: :any_skip_relocation, big_sur:        "ef98143cc490b50bd05b22fbff34f15949982ecc131c52838db3f0258cd4d65e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6a9003a50b699149bb99c46e81292f4f1b49d7a6380d723ee78123aca41b5596"
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
