class Pyinstaller < Formula
  include Language::Python::Virtualenv

  desc "Bundle a Python application and all its dependencies"
  homepage "https://pyinstaller.org/"
  url "https://files.pythonhosted.org/packages/87/0b/0b9cfa5ed2ffcb9f3ae4335c436e4e250a5ea4c4d7dac4a693ed7f2b14dd/pyinstaller-5.9.0.tar.gz"
  sha256 "2bde16a8d664e8eba9aa7b84f729f7ab005c1793be4fe1986b3c9cad6c486622"
  license "GPL-2.0-or-later"
  head "https://github.com/pyinstaller/pyinstaller.git", branch: "develop"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0b2ca34db0f42d9d96dddfb986867ae632af026b76b6562e1b7adb0519712bf2"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "97ce83b12a20f9985748c567a1bfb9b398fcc8b4777248c83bc4f85fe45d772b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e7c9fad75cec238a122ce550b8a010089bbef09f505075016582f63c2a794d8"
    sha256 cellar: :any_skip_relocation, ventura:        "858dcbfed086243ab0bc456f261c79fb5b7a976db34cbd28d8f909d780f3dd9f"
    sha256 cellar: :any_skip_relocation, monterey:       "b124294203838050949e354c8e292ff8ea360f86263298635392833a10320d6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d52e96d8bf4ecaa807a45a195d76705260fefc4ac52b821788ca52f767a4794"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3351e3ba567c84c323572267799b0ed47f34d1a138d965f789bbba20bd6aaf87"
  end

  depends_on "python@3.11"

  resource "altgraph" do
    url "https://files.pythonhosted.org/packages/5a/13/a7cfa43856a7b8e4894848ec8f71cd9e1ac461e51802391a3e2101c60ed6/altgraph-0.17.3.tar.gz"
    sha256 "ad33358114df7c9416cdb8fa1eaa5852166c505118717021c6a8c7c7abbd03dd"
  end

  resource "macholib" do
    url "https://files.pythonhosted.org/packages/46/92/bffe4576b383f20995ffb15edccf1c97d2e39f9a8c72136836407f099277/macholib-1.16.2.tar.gz"
    sha256 "557bbfa1bb255c20e9abafe7ed6cd8046b48d9525db2f9b77d3122a63a2a8bf8"
  end

  resource "pyinstaller-hooks-contrib" do
    url "https://files.pythonhosted.org/packages/6b/74/1d010b2f86db7dd4622a52a69f53c7cdfe60564def3cfcfb9fb1f141406d/pyinstaller-hooks-contrib-2023.0.tar.gz"
    sha256 "bd578781cd6a33ef713584bf3726f7cd60a3e656ec08a6cc7971e39990808cc0"
  end

  def install
    cd "bootloader" do
      system "python3.11", "./waf", "all", "--no-universal2", "STRIP=/usr/bin/strip"
    end
    virtualenv_install_with_resources
  end

  test do
    (testpath/"easy_install.py").write <<~EOS
      """Run the EasyInstall command"""

      if __name__ == '__main__':
          from setuptools.command.easy_install import main
          main()
    EOS
    system bin/"pyinstaller", "-F", "--distpath=#{testpath}/dist", "--workpath=#{testpath}/build",
                              "#{testpath}/easy_install.py"
    assert_predicate testpath/"dist/easy_install", :exist?
  end
end
