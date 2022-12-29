class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/39/6a/63951ee6926e4da54968daf4e885c44e40d0ff1379f53c48a2f811176f27/tmuxp-1.22.1.tar.gz"
  sha256 "a46e51108b8e2c89dcd157aa51a1cf4914df49a3414fd07c475de83ee8bfcbf4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "691ac38ca9692698bad61fce3373bc4b24b05153d0142373abb8b55ccbd652e9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37b85874b8bc8df657cc565f374ab620082e807649f536bb31518d1e9ac0ac7a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1987ae2ea42aeb4d8a322f47c933eed82c8f4f9a8e5020ff8bbaf546cae65dd3"
    sha256 cellar: :any_skip_relocation, ventura:        "82086d6de4032e5c900cdf5efbaca5db23c2fef92d7d3ebf3419efd96946ace0"
    sha256 cellar: :any_skip_relocation, monterey:       "4242455226339cbb7b599149b3ef1b2beb43667ed8cfa0f5c442d16b69a5a970"
    sha256 cellar: :any_skip_relocation, big_sur:        "0db303cb737cabb7f65ffa317d05a649d508f05b797388616b0210751a62da40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c46a00501512603d9f4c31c3c3f0dbdbe5abede75fd9fae42a53f18a58a5d86f"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/a3/00/152dfa302946c8ce4cfa5fb58fe29ee3f3d477624270786c2e3739b8fbda/libtmux-0.18.1.tar.gz"
    sha256 "212cff87ec679a269ae430125c636221d2e2458f7626bd5ba00dceb68f02db91"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/tmuxp --version")

    (testpath/"test_session.yaml").write <<~EOS
      session_name: 2-pane-vertical
      windows:
      - window_name: my test window
        panes:
          - echo hello
          - echo hello
    EOS

    system bin/"tmuxp", "debug-info"
    system bin/"tmuxp", "convert", "--yes", "test_session.yaml"
    assert_predicate testpath/"test_session.json", :exist?
  end
end
