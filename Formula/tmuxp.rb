class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/f4/f2/caa86fe8ab4d2340a92c40150649a37d15a28dc2016edefc110432cdb977/tmuxp-1.22.0.tar.gz"
  sha256 "ea6f3f88a58d4c33217d677414849b5a42ce698e0443bcfa4963e6785529b16c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2751453c73e86c52371635746a3c57c15bbd8c31234369b6e69aff808a9271ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dad2fd9a5eabe89de9f831d9635aa46650797762ff6d67e14625458e572d4489"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04e108a2f756715d4be5764644efa0a6df6a9dcc86ba193b41544a56a3fc3c30"
    sha256 cellar: :any_skip_relocation, ventura:        "9cfae87cd74a6dde34de34719ab415e9222083a0b78f384766c84d76d2d090de"
    sha256 cellar: :any_skip_relocation, monterey:       "9966a07347fca4f7a4c5e4e593c9558c738f8ae5562cb9581c93cc49e9218d14"
    sha256 cellar: :any_skip_relocation, big_sur:        "c1eba8548088fa2b3def269ce8bd302e3bb65060126b5cea3a4422769e79766d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ffd260ea4a99716cdab7406693bf77ce73005d66c4b85f55f498e343467beab"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/db/88/d42e629a52be35ff4774d8f154bfe1c263ab2ee37f069fa792f0423bf530/libtmux-0.18.0.tar.gz"
    sha256 "c51ccd5ef5ff18232fd56a72cadddd36bf3ad79e0dbd34cdad4a06d821a2af84"
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
