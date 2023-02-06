class Virtualenv < Formula
  include Language::Python::Virtualenv

  desc "Tool for creating isolated virtual python environments"
  homepage "https://virtualenv.pypa.io/"
  url "https://files.pythonhosted.org/packages/22/a2/90da38a06254d3df8319c970586babc7cb8862787c9fa579b8c1eacfd5c7/virtualenv-20.18.0.tar.gz"
  sha256 "f262457a4d7298a6b733b920a196bf8b46c8af15bf1fd9da7142995eff15118e"
  license "MIT"
  head "https://github.com/pypa/virtualenv.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b6433eccf52ce3b733b122932e64c2446bedfbec22f5bcf84ab6323968541dca"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a86a36013d8fb5f6878ff0fcfa37cce0db787a141ef9221f92f9d05b3075ca47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "483243cfbff1224994175b773bb622e0acdf4acba3af10c0d377ec68aa11d20d"
    sha256 cellar: :any_skip_relocation, ventura:        "cbd564239827182063e09cbd58dfaecb54abc213612a7ae86fab8a1cfdf9da9d"
    sha256 cellar: :any_skip_relocation, monterey:       "1bb516dae5be32bb7953aa9109fc70d4f7e4f9a84f13f092d0e567b550611970"
    sha256 cellar: :any_skip_relocation, big_sur:        "d30200f296078f3ed33873306afbec5dc59def61be4b44926fff655d00dfb50c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c8fc9ae634e4488637972c71ee3d410cee13349b710d0982010d09d07244352a"
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
    url "https://files.pythonhosted.org/packages/cf/4d/198b7e6c6c2b152f4f9f4cdf975d3590e33e63f1920f2d89af7f0390e6db/platformdirs-2.6.2.tar.gz"
    sha256 "e1fea1fe471b9ff8332e229df3cb7de4f53eeea4998d3b6bfff542115e998bd2"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    system "#{bin}/virtualenv", "venv_dir"
    assert_match "venv_dir", shell_output("venv_dir/bin/python -c 'import sys; print(sys.prefix)'")
  end
end
