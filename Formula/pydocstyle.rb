class Pydocstyle < Formula
  include Language::Python::Virtualenv

  desc "Python docstring style checker"
  homepage "https://www.pydocstyle.org/"
  url "https://files.pythonhosted.org/packages/b7/c7/01674c093a29cc83261d2cd554dd9d0debf8cfad061c05359a5d18562863/pydocstyle-6.2.1.tar.gz"
  sha256 "5ddccabe3c9555d4afaabdba909ca2de4fa24ac31e2eede4ab3d528a4bcadd52"
  license "MIT"
  head "https://github.com/PyCQA/pydocstyle.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2d32bd2370cf0c6e7bdc3afff9661380cf1050d631dc1ee417ea3bab16a720d8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "73f2d0ef3d21a6746434c3578d44486baf8d1b7cef240cd71c717c33b16e48cc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33e20d88202debbe9e679c74decc18a4f09043da3fd927866aef482cf2be20df"
    sha256 cellar: :any_skip_relocation, ventura:        "e8bf2a91fe6ad37749583ff14d830effce80e1fb21a7a197bb382e6b9461408d"
    sha256 cellar: :any_skip_relocation, monterey:       "e5bd1c82cde39e8971673a1693f18cb845d6d683f9f13b6000657fe05fc4a5a7"
    sha256 cellar: :any_skip_relocation, big_sur:        "5574481a6a7b75ea780196684da29a91555e3eb72b48da4e4ac3a3a1f01bad1b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d89fa0edfcf8bd9ce19f2384924eec93156081035e39495e0076b712e466f01f"
  end

  depends_on "python@3.11"

  resource "snowballstemmer" do
    url "https://files.pythonhosted.org/packages/44/7b/af302bebf22c749c56c9c3e8ae13190b5b5db37a33d9068652e8f73b7089/snowballstemmer-2.2.0.tar.gz"
    sha256 "09b16deb8547d3412ad7b590689584cd0fe25ec8db3be37788be3810cbf19cb1"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"broken.py").write <<~EOS
      def bad_docstring():
        """  extra spaces  """
        pass
    EOS
    output = pipe_output("#{bin}/pydocstyle broken.py 2>&1")
    assert_match "No whitespaces allowed surrounding docstring text", output
  end
end
