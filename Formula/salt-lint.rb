class SaltLint < Formula
  include Language::Python::Virtualenv

  desc "Check for best practices in SaltStack"
  homepage "https://github.com/warpnet/salt-lint"
  url "https://files.pythonhosted.org/packages/ad/42/9780ad0ffefc15421a4d586ba0f6f38b8a2c44794c37312a06a3e4e983f6/salt-lint-0.9.0.tar.gz"
  sha256 "057a410e505d2c53602a55f1824bcd7b48970ef4d88589c7b461f001f1f8b7d9"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "87fc6f52e39cca360c96a70a329080dae9beed83737c8b6f9127962bde43ae25"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5854dd0330baaf0f6d0d26fe4e0910932164de550fc5759b1d2832f6aa646a51"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a9f38d3c5d28634fb1543ba4ba6f61c1e97719e2bed569132968d532260cbf44"
    sha256 cellar: :any_skip_relocation, ventura:        "d22336a46b4e08fbb17f7220a5bbf145c5429ecd59fafe29b42c216770878a61"
    sha256 cellar: :any_skip_relocation, monterey:       "23df453884270f756913358f4b7e1d9fc6b08a92e72d180a9646060e0458376e"
    sha256 cellar: :any_skip_relocation, big_sur:        "05150cd861ee2d091d7a006e2026adec3a08c6d4f0b35515916ee911c9853acb"
    sha256 cellar: :any_skip_relocation, catalina:       "74394670e09ff7757149be51d66049b0d0b3d8cb2f2dfe3c8fe2cbb9f517911f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "68913a999bbfa7d99438aa023989b8d453e8f32ebba446075261372bf98e06d6"
  end

  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/32/1a/6baf904503c3e943cae9605c9c88a43b964dea5b59785cf956091b341b08/pathspec-0.10.3.tar.gz"
    sha256 "56200de4077d9d0791465aa9095a01d421861e405b5096955051deefd697d6f6"
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
    out = shell_output("salt-lint #{testpath}/test.sls", 2)
    assert_match "[206] Jinja variables should have spaces before and after: '{{ var_name }}'", out
  end
end
