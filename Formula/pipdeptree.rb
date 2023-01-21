class Pipdeptree < Formula
  include Language::Python::Virtualenv

  desc "CLI to display dependency tree of the installed Python packages"
  homepage "https://github.com/tox-dev/pipdeptree"
  url "https://files.pythonhosted.org/packages/99/02/1f0f5e6ec82d22bb7c68b699d626f46a41d05f8e32269b2543348d345734/pipdeptree-2.3.3.tar.gz"
  sha256 "9d666f77ff1b9528d01b3d98594096484f56de70d752abe22f13e681be239bd8"
  license "MIT"

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    expected = <<~EOS
      pip==22.3.1
      pipdeptree==2.3.3
      setuptools==65.6.3
      wheel==0.38.4
    EOS
    assert_equal expected, shell_output("#{bin}/pipdeptree --all")

    assert_empty shell_output("#{bin}/pipdeptree --user-only").strip

    assert_equal version.to_s, shell_output("#{bin}/pipdeptree --version").strip
  end
end
