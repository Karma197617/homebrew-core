class PythonMarkdown < Formula
  include Language::Python::Virtualenv

  desc "Python implementation of Markdown"
  homepage "https://python-markdown.github.io"
  url "https://files.pythonhosted.org/packages/66/bf/a7c9e8cc23c105633b74e3280c2b06d13273da0df389e59395188d440017/Markdown-3.4.2.tar.gz"
  sha256 "e104be388c28462b4e83bd0ddfc68eff6022305cc4b5ab14caf8d235fae132b9"
  license "BSD-3-Clause"
  head "https://github.com/Python-Markdown/markdown.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3237d2dbf41e0291bef1fcc02d194d76706ca8db670386d9d1736f3f2271ceea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f41ee4085d159af4cbd5a51fc12290dd682a7b6fba59398d9702f4519cb09529"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7644ec48efb17d9a826aba4aacfdb08ce5bba49b24daf8006f1ef697aa46f86e"
    sha256 cellar: :any_skip_relocation, ventura:        "4f2b93709d5b43ee72a61577b33cdd83c7bb107ba7792f98be3b0d76db36261b"
    sha256 cellar: :any_skip_relocation, monterey:       "3eabeee2e6c92e05e8b6022103c3f52ad6892ab9a76427e027997101befe1b57"
    sha256 cellar: :any_skip_relocation, big_sur:        "0cbfab72f7a57af0433d1fcaa0e8c7be91d76db59f456c5b684c25fe9ae1eb9a"
    sha256 cellar: :any_skip_relocation, catalina:       "47b4e7d7aabf71c2c879d855773ed72fab2e31bac5b3cdf65010f300d0b70b26"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf60875a580a8446afa3d4c7d95f4bb9811fbb39ce61890cd2703d6558802f7f"
  end

  depends_on "python@3.11"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.md").write("# Hello World!")
    assert_equal "<h1>Hello World!</h1>", shell_output(bin/"markdown_py test.md").strip
  end
end
