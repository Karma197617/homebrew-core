class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.5.2.tar.gz"
  sha256 "27b3fe85315322dbfa3f5c7622af3a0d8a343b85910d3a0f760f4ebb9246be52"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f17aef3d7c07bd303172a857bd6c4ee92ce03c9395ede0f93e6ea85fa960e8bc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "37a05e9d0fdbbc21978f1305d51f935f24db508c95483c9651262a7394386690"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f1cb531d909356530df161c3cf9b2353e598c3b809662167d546aad839942f8f"
    sha256 cellar: :any_skip_relocation, ventura:        "bdff183e397afed0affd0ab40e8f0f1ca49abcc7878d671d690a679afefab3ed"
    sha256 cellar: :any_skip_relocation, monterey:       "9fac91e6a163cc737d1da8299846fb27a9b3919b6fd1135f1816a4e7e404628e"
    sha256 cellar: :any_skip_relocation, big_sur:        "e71639ffeed3dad7c11048742190c78342ae487b30a97c6efbbd965ef0925592"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c5a6a0979d10f69f6931779a1dc4dec15723c38397937144607a44cdee411114"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "prqlc", *std_cargo_args(path: "prql-compiler/prqlc")
  end

  test do
    stdin = "from employees | filter has_dog | select salary"
    stdout = pipe_output("#{bin}/prqlc compile", stdin)
    assert_match "SELECT", stdout
  end
end
