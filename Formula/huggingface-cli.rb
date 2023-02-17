class HuggingfaceCli < Formula
  include Language::Python::Virtualenv

  desc "Client library for huggingface.co hub"
  homepage "https://huggingface.co/docs/huggingface_hub/index"
  url "https://files.pythonhosted.org/packages/90/d7/4629218f05e188e21b4d68decda8566ff6898013f5e96f4d8caf9211d701/huggingface_hub-0.12.1.tar.gz"
  sha256 "6f960f6246ef9c3446d0d6275e853485515682c350917fdaf2a59705f8b9ebb3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cda2872eba0077cb2c8c178e30e2df2d07c48675c497d3c4c492bed97f9be63d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a1d2a802e01a0bf6992e9ac9d54b18b9a5ed3e9a1e51dd2f96c094902136be4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "04d5019a0bcd39a7fca5650483d7e2a384ced86978f2308a2354bd190e6a6c1d"
    sha256 cellar: :any_skip_relocation, ventura:        "e51c71c193a0010c9be7b0bdc3a56daf90c23874816f8f7a96fb190e8f0c9cd0"
    sha256 cellar: :any_skip_relocation, monterey:       "17c1a51862a3a3502afbac8c0030c281fbddf09177b03c1c05a12ee56c3f75ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "b877f4bfbc4614da4ad78196c628f8ad04f5deab0fdb43d80fb87561b981d1eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5cf57b908648af2fb45a9ac6087d1adf2f90b8764ff12fa721d1f9bdbc07edc0"
  end

  depends_on "git-lfs"
  depends_on "python-typing-extensions"
  depends_on "python@3.11"
  depends_on "pyyaml"

  resource "certifi" do
    url "https://files.pythonhosted.org/packages/37/f7/2b1b0ec44fdc30a3d31dfebe52226be9ddc40cd6c0f34ffc8923ba423b69/certifi-2022.12.7.tar.gz"
    sha256 "35824b4c3a97115964b408844d64aa14db1cc518f6562e8d7261699d1350a9e3"
  end

  resource "charset-normalizer" do
    url "https://files.pythonhosted.org/packages/96/d7/1675d9089a1f4677df5eb29c3f8b064aa1e70c1251a0a8a127803158942d/charset-normalizer-3.0.1.tar.gz"
    sha256 "ebea339af930f8ca5d7a699b921106c6e29c617fe9606fa7baa043c1cdae326f"
  end

  resource "filelock" do
    url "https://files.pythonhosted.org/packages/0b/dc/eac02350f06c6ed78a655ceb04047df01b02c6b7ea3fc02d4df24ca87d24/filelock-3.9.0.tar.gz"
    sha256 "7b319f24340b51f55a2bf7a12ac0755a9b03e718311dac567a0f4f7fabd2f5de"
  end

  resource "idna" do
    url "https://files.pythonhosted.org/packages/8b/e1/43beb3d38dba6cb420cefa297822eac205a277ab43e5ba5d5c46faf96438/idna-3.4.tar.gz"
    sha256 "814f528e8dead7d329833b91c5faa87d60bf71824cd12a7530b5526063d02cb4"
  end

  resource "packaging" do
    url "https://files.pythonhosted.org/packages/47/d5/aca8ff6f49aa5565df1c826e7bf5e85a6df852ee063600c1efa5b932968c/packaging-23.0.tar.gz"
    sha256 "b6ad297f8907de0fa2fe1ccbd26fdaf387f5f47c7275fedf8cce89f99446cf97"
  end

  resource "requests" do
    url "https://files.pythonhosted.org/packages/9d/ee/391076f5937f0a8cdf5e53b701ffc91753e87b07d66bae4a09aa671897bf/requests-2.28.2.tar.gz"
    sha256 "98b1b2782e3c6c4904938b84c0eb932721069dfdb9134313beff7c83c2df24bf"
  end

  resource "tqdm" do
    url "https://files.pythonhosted.org/packages/c1/c2/d8a40e5363fb01806870e444fc1d066282743292ff32a9da54af51ce36a2/tqdm-4.64.1.tar.gz"
    sha256 "5f4f682a004951c1b450bc753c710e9280c5746ce6ffedee253ddbcbf54cf1e4"
  end

  resource "urllib3" do
    url "https://files.pythonhosted.org/packages/c5/52/fe421fb7364aa738b3506a2d99e4f3a56e079c0a798e9f4fa5e14c60922f/urllib3-1.26.14.tar.gz"
    sha256 "076907bf8fd355cde77728471316625a4d2f7e713c125f51953bb5b3eecf4f72"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    whoami_output = shell_output("#{bin}/huggingface-cli whoami")
    assert_match "Not logged in", whoami_output
    test_cache = testpath/"cache"
    test_cache.mkdir
    ENV["HUGGINGFACE_HUB_CACHE"] = test_cache.to_s
    ENV["NO_COLOR"] = "1"
    scan_output = shell_output("#{bin}/huggingface-cli scan-cache")
    assert_match "Done in 0.0s. Scanned 0 repo(s) for a total of 0.0.", scan_output
  end
end
