class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/3d/ad/906d59bbcb0e6178989cee52166a8a6651ddaea18b38e728eaac22e61cad/virtualenv-20.19.0.tar.gz"
  sha256 "37a640ba82ed40b226599c522d411e4be5edb339a0c0de030c0dc7b646d61590"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4da0d7f3826b3d2be2b10978e9ac82cb05563bbf3f1dae306526ebf2483f5c75"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d62f5c513874dc31d143431b7add6c4190e02847b65ae4f1796b09f0fe15d5ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e3b19fd9882bb73e3e68824ec3d536020d83bf1ff203bc36c7cdf4fea896606"
    sha256 cellar: :any_skip_relocation, ventura:        "89b73a3b6b037a0f2a55055ae08811867ba8db7445c3a9199aa4e1c5ee731859"
    sha256 cellar: :any_skip_relocation, monterey:       "b13db04876049b1486b68cdda23f85974e300c74edebd8e86d71f98c2d3be3af"
    sha256 cellar: :any_skip_relocation, big_sur:        "0801d1ad70022cd3a2d1f48f0280cc6f51e096f8f27a5935618c875c53b1e80a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7b1a2529a52ff492f2a76566e6067466b272c9a581671bdb30139f130a044af3"
  end

  depends_on "python@3.11"

  resource "distlib" do
    url "https://files.pythonhosted.org/packages/58/07/815476ae605bcc5f95c87a62b95e74a1bce0878bc7a3119bc2bf4178f175/distlib-0.3.6.tar.gz"
    sha256 "14bad2d9b04d3a36127ac97f30b12a19268f211063d8f8ee4f47108896e11b46"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/11/39/702094fc1434a4408783b071665d9f5d8a1d0ba4dddf9dadf3d50e6eb762/platformdirs-3.0.0.tar.gz"
    sha256 "8a1228abb1ef82d788f74139988b137e78692984ec7b08eaa6c65f1723af28f9"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
