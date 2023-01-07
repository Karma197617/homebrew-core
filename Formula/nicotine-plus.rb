class NicotinePlus < Formula
  include Language::Python::Virtualenv

  desc "Graphical client for the Soulseek file sharing network"
  homepage "https://nicotine-plus.github.io/nicotine-plus/"
  url "https://files.pythonhosted.org/packages/33/42/09d44ca8a6ee8eb9982e6e289bcc4523cbd8f2290decc3a07655c1a22bfd/nicotine-plus-3.2.8.tar.gz"
  sha256 "48e1bcda9483f3d2228f8c4ff6fe68f1b61898c354d54b1358726997b926b283"
  license "GPL-3.0-or-later"
  head "https://github.com/Nicotine-Plus/nicotine-plus.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6b130f107b367173db41569066a2f22ed78ae86ab0be8bc4b37fba6f5bd8032"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b6b130f107b367173db41569066a2f22ed78ae86ab0be8bc4b37fba6f5bd8032"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b6b130f107b367173db41569066a2f22ed78ae86ab0be8bc4b37fba6f5bd8032"
    sha256 cellar: :any_skip_relocation, ventura:        "5adb9741d2fea95d0551e029070b45b72eea27ce84adfca7dc97c3d4ebb1056f"
    sha256 cellar: :any_skip_relocation, monterey:       "5adb9741d2fea95d0551e029070b45b72eea27ce84adfca7dc97c3d4ebb1056f"
    sha256 cellar: :any_skip_relocation, big_sur:        "5adb9741d2fea95d0551e029070b45b72eea27ce84adfca7dc97c3d4ebb1056f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fd6c703853effbc147cf7224f9ae418bf12a2435a023999202b51d70c78ba835"
  end

  depends_on "adwaita-icon-theme"
  depends_on "gtk+3"
  depends_on "py3cairo"
  depends_on "pygobject3"
  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/nicotine -v")
    pid = fork do
      exec bin/"nicotine", "-s"
    end
    sleep 3
    Process.kill("TERM", pid)
  end
end
