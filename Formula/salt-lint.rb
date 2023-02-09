class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/e5/e9/4df64ca147c084ca1cdbea9210549758d07f4ed94ac37d1cd1c99288ef5c/salt-lint-0.9.2.tar.gz"
  sha256 "7f74e682e7fd78722a6d391ea8edc9fc795113ecfd40657d68057d404ee7be8e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7da0b526506b37fa0eaa7de82830af5de532e5f774856b818f5b292b4b7fa38e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "02bd28d1dd0aa195205cd5655e5651902f7c1e0ff4cab8c45921d63883f1eeb9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8524598b64d3fd49701a98dcc483c034776b579a2c96422f5ad0a9d46632b27f"
    sha256 cellar: :any_skip_relocation, ventura:        "3042a1d9a3fe65962c2488b00a08dbe7141defd4f11147966d1988720e2b1f80"
    sha256 cellar: :any_skip_relocation, monterey:       "61f299ba3fa4ed095ad33ab53dd4a9da37f375d013c922f45441eb3a49d37e8b"
    sha256 cellar: :any_skip_relocation, big_sur:        "c09182242226685923b180c697093ebe5e27dca0e1e502c2fab829ef85ec711c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88e9a00859ee9f3aedf7fbe0cdd5c245cc0c8c254dd04dd47e9dbb0c56bc7e2a"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/f4/8e/f91cffb32740b251cff04cad1e7cdd2c710582c735a01f56307316c148f2/pathspec-0.11.0.tar.gz"
    sha256 "64d338d4e0914e91c1792321e6907b5a593f1ab1851de7fc269557a21b30ebbc"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.sls").write <<~EOS
      /tmp/testfile:
        file.managed:
            - source: salt://{{unspaced_var}}/example
    EOS
    out = shell_output("#{bin}/salt-lint #{testpath}/test.sls", 2)
    assert_match "[206] Jinja variables should have spaces before and after: '{{ var_name }}'", out
  end
end
