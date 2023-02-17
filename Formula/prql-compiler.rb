class PrqlCompiler < Formula
  desc "Simple, powerful, pipelined SQL replacement"
  homepage "https://prql-lang.org"
  url "https://github.com/prql/prql/archive/refs/tags/0.5.1.tar.gz"
  sha256 "dfb595417934a6b7fca09a2857e8ab0ac696123a2f1759c2868d1bd1e24134c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c397b4cc9467b65510bdab42794a697533fc8fc8962a171f1199de89840f67d7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a50e59b46cad161b62f1a84d6d547c03ee311553bc9b0fcd47708b84d7803391"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6a51be8e8b27785cd005cc1d8d04a3d50f57d9b12b0bd23242a93c44ebb2300a"
    sha256 cellar: :any_skip_relocation, ventura:        "ac603f35a93ad7499b206ee79bc3bd47b9c4ad6cfd4e303469017f936844fbce"
    sha256 cellar: :any_skip_relocation, monterey:       "9d830b3460293f72a97903f55488ab6ac0e5e68dfbaddea99b918d9daabeae36"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9f6f229a045edda82586ac66ceb432c8a7da15a6e9e454bad7b9c334dcdfb97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6c0ec0773b661fff04d6ef436700bca38747807c5c89e1610c0ba48bd0cf8d2c"
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
