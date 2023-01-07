class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/7b/a3/8e9c68b703db2a4756704c08893b5b44c3ecae4e0515a9aafdac2604e7bb/tmuxp-1.24.1.tar.gz"
  sha256 "62e961e5bd1daecd0574a0ee38deb1e78cf6798a8d06985dd806e9f9740ca5c2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cbf93a77a361d554d5d7f7543dfcb9e65901ac30385497ce8d09e3ca42db029d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8be8271690f325d5999803512865e21ebe8f963f16c7743b9dc8c73ac89e8e05"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a60aafb8cddb500ce522a5b4a0bf3ee37e62692cb347ae39679fddf79ee3d1df"
    sha256 cellar: :any_skip_relocation, ventura:        "7de6d0ac96974b76a6fe8ae6062b7960fc404dd8a53929cae6ef5a33c46c4352"
    sha256 cellar: :any_skip_relocation, monterey:       "7402a7502c3b47432672b64144c927b7e266856c736918a377c0b4b372bc0a84"
    sha256 cellar: :any_skip_relocation, big_sur:        "41053ffdf23100e8c26df9af76e7cc48bad291d99e42390523b1461bd3c1f471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "49c498c5c35f2c48d0be44c8a266d14b53cddb52fc1301fa60b2c6f55eff1ae4"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/d2/33/c70c5f119ade04cda33e8fe0bde7a5707f2cefa1c6fb52cdbbadd958e8ab/libtmux-0.18.3.tar.gz"
    sha256 "3ea19ac20498342e2ed8334d18d9dc45a03f9c84c28eb613ed76a2ae38fde141"
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
