class TrashCli < Formula
  include Language::Python::Virtualenv

  desc "Command-line interface to the freedesktop.org trashcan"
  homepage "https://github.com/andreafrancia/trash-cli"
  url "https://files.pythonhosted.org/packages/42/2c/f9e598025b133d170e35becaef27fdfa86c7279d2715d20b517468c80c76/trash-cli-0.23.2.13.2.tar.gz"
  sha256 "99805170df2af7b291314d5b9d86b2cfd598e635a5a23d32debfede880021044"
  license "GPL-2.0-or-later"
  head "https://github.com/andreafrancia/trash-cli.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "783f8a90b57013c3d805000e3f7e2966b61037980655ef193bc5a64453fe2b42"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0ae573265f69e2ca674d73a261ff27451108938c8cef999c071d7d1f704eccb1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5e0297996b7296604a3999834bf9d199ab645bcce73b0429446c4dbb57b25cda"
    sha256 cellar: :any_skip_relocation, ventura:        "e4ad8b00754a30f6f1bdbec8b194d8c7efbcd369b3dafd651175b528813143ff"
    sha256 cellar: :any_skip_relocation, monterey:       "455b0229a0f8e1ea0f2daf18bc39bd52e76036d59df4873e888ad251e23b9973"
    sha256 cellar: :any_skip_relocation, big_sur:        "9472fa4fe5d5b04e1d856e39f159f3a38b220ad09e96c7eb22d2dd15f979f0af"
    sha256 cellar: :any_skip_relocation, catalina:       "8451101a8557e07b2474b0db71f76663bb7edc0e9626c3b1e92cd94bcfa0da5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "15554cb331443b20939188eee31764ad0d0fce83666d43fd63acbb0b4d3148b9"
  end

  depends_on "python@3.11"
  depends_on "six"

  conflicts_with "macos-trash", because: "both install a `trash` binary"
  conflicts_with "trash", because: "both install a `trash` binary"

  resource "psutil" do
    url "https://files.pythonhosted.org/packages/3d/7d/d05864a69e452f003c0d77e728e155a89a2a26b09e64860ddd70ad64fb26/psutil-5.9.4.tar.gz"
    sha256 "3d7f9739eb435d4b1338944abe23f49584bde5395f27487d2ee25ad9a8774a62"
  end

  resource "typing" do
    url "https://files.pythonhosted.org/packages/05/d9/6eebe19d46bd05360c9a9aae822e67a80f9242aabbfc58b641b957546607/typing-3.7.4.3.tar.gz"
    sha256 "1187fb9c82fd670d10aa07bbb6cfcfe4bdda42d6fab8d5134f04e8c4d0b71cc9"
  end

  def install
    virtualenv_install_with_resources
    man1.install_symlink libexec.glob("share/man/man1/trash*.1")
  end

  test do
    touch "testfile"
    assert_predicate testpath/"testfile", :exist?
    system bin/"trash-put", "testfile"
    refute_predicate testpath/"testfile", :exist?
  end
end
