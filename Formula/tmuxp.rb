class Tmuxp < Formula
  include Language::Python::Virtualenv

  desc "Tmux session manager. Built on libtmux"
  homepage "https://tmuxp.git-pull.com/"
  url "https://files.pythonhosted.org/packages/9e/ca/83628559a0ac7ba038187ddd82cf684b986cac5070b3eea1ad7e684cbca3/tmuxp-1.24.0.tar.gz"
  sha256 "190b46a4a3e185f994156e3621eb483eaee535764bb0efa14d704e297ffcf725"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "539062183f57b8f517747b7e939e2c0cf07b2c6076efa819ed153cd1f8fe0781"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "dd74e84180a2fed476487a4abbafa09166a19173a12d40712aa5e2c05b197dba"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8861f4f207d0826ba472a728816a99a32e3d9c230835a7eff557153be6fb60e4"
    sha256 cellar: :any_skip_relocation, ventura:        "8837fffcfb1de6b16cf142bc7b1e6eaf2eac15a4045dcb184057b63f48211add"
    sha256 cellar: :any_skip_relocation, monterey:       "217d0765a7fb6ed63e42c0925a98bea9cdbf95999126462dd138ff3d8e59eecd"
    sha256 cellar: :any_skip_relocation, big_sur:        "c229d65f36498d3597c5a96db54f6a328a2f546f98927fcb84c3b65d84f8028f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "647415fe9d4ec5fb7d9a16f9c858a39b712eeef348a4bf41a080ee3a471d0ae0"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"
  depends_on "tmux"

  resource "colorama" do
    url "https://files.pythonhosted.org/packages/d8/53/6f443c9a4a8358a93a6792e2acffb9d9d5cb0a5cfd8802644b7b1c9a02e4/colorama-0.4.6.tar.gz"
    sha256 "08695f5cb7ed6e0531a20572697297273c47b8cae5a63ffc6d6ed5c201be6e44"
  end

  resource "libtmux" do
    url "https://files.pythonhosted.org/packages/55/3b/81083e63772fbfdcdc42edf0908aa854ed7f9baa4ccb01a1ef73d408ae62/libtmux-0.18.2.tar.gz"
    sha256 "61a8245766ccfeebeeb64a66014f3c9a614b108a2b9527f81b30ecf68a6806b1"
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
