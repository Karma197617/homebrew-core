require "language/node"

class Quicktype < Formula
  desc "Generate types and converters from JSON, Schema, and GraphQL"
  homepage "https://github.com/quicktype/quicktype"
  # quicktype should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/quicktype/-/quicktype-21.0.0.tgz"
  sha256 "171d4e07530c1e946f6fef4ad9e6f477cb1f6f27a147e77a740b46372cf6f1e4"
  license "Apache-2.0"
  head "https://github.com/quicktype/quicktype.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "967716fdf0397d54c32e0e4dbcc500ce28f5d980e511c723ef48c977b077fdda"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "967716fdf0397d54c32e0e4dbcc500ce28f5d980e511c723ef48c977b077fdda"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "967716fdf0397d54c32e0e4dbcc500ce28f5d980e511c723ef48c977b077fdda"
    sha256 cellar: :any_skip_relocation, ventura:        "31a8f5696f82d214770f7a184ffd2223eb9c02bffe6deddf5725e3d4670bcac6"
    sha256 cellar: :any_skip_relocation, monterey:       "31a8f5696f82d214770f7a184ffd2223eb9c02bffe6deddf5725e3d4670bcac6"
    sha256 cellar: :any_skip_relocation, big_sur:        "31a8f5696f82d214770f7a184ffd2223eb9c02bffe6deddf5725e3d4670bcac6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "967716fdf0397d54c32e0e4dbcc500ce28f5d980e511c723ef48c977b077fdda"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"sample.json").write <<~EOS
      {
        "i": [0, 1],
        "s": "quicktype"
      }
    EOS
    output = shell_output("#{bin}/quicktype --lang typescript --src sample.json")
    assert_match "i: number[];", output
    assert_match "s: string;", output
  end
end
