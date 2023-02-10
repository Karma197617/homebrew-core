class RdiffBackup < Formula
  desc "Reverse differential backup tool, over a network or locally"
  homepage "https://rdiff-backup.net/"
  url "https://files.pythonhosted.org/packages/2e/8a/2cae44db2063a678937b68f24300b60aed15488ce1eb1a6da56052bf86ba/rdiff-backup-2.2.3.tar.gz"
  sha256 "0ec0e7c75277fa3f1d02fcc9c91c0b58e10c5e625cefd5ffd6b56ec293878fc9"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "b4e11a49c4888bce8920430c2042a6034806a67768c45023c85efa3a1af36ad7"
    sha256 cellar: :any,                 arm64_monterey: "3cfe003a25a7d4f7f27e4d716041f92368cd4ef1ff22f231990d6bef380280a4"
    sha256 cellar: :any,                 arm64_big_sur:  "dd2da1a5ac17e138f72538e3ee6d7592ebd6a575ebfd94a4b1b4c142862c15d7"
    sha256 cellar: :any,                 ventura:        "2a65e95df9c32cb6e1c41d1dc4e1ded63d44ed28bb6466ddd1f99c74b6eeb5c1"
    sha256 cellar: :any,                 monterey:       "828b1068920c6b889229a092b336f084d7091428fa4bf3eb50ecd7702f0b8784"
    sha256 cellar: :any,                 big_sur:        "12dc2fffc9c4a6eb0e51c49c9ac51aeab3d48c706d648db0f68c93265388b6c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "abd7d3b18ca4df730698e40ecf04a5a46bffac45679a316804a73fc315714a94"
  end

  depends_on "librsync"
  depends_on "python@3.11"
  depends_on "pyyaml"

  def install
    python3 = "python3.11"
    system python3, *Language::Python.setup_install_args(prefix, python3), "--install-data=#{prefix}"
  end

  test do
    system "#{bin}/rdiff-backup", "--version"
  end
end
