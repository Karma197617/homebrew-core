class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.84.0.tar.gz"
  sha256 "8faecbf947eda0a8dc3dd7c1c85607a87051c5e39a8ca9095099988127fabb21"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "054c4c84d8f14352e345bec075e7a4b9cd99accdd79333fceabaade047773131"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3f5c751fa9a1ed219471a2f20371d93d889d98278b540650fc1ae7d966af0aa1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "99f114e2814ee0fa635bbb7f9556d0a54d350138d42e3c6836fe0e061e36e0d7"
    sha256 cellar: :any_skip_relocation, ventura:        "02a536bb73bd704e5ad55e403cf55cca98e1e07f096c073d3ad05b37b3c965eb"
    sha256 cellar: :any_skip_relocation, monterey:       "26eccd35b1976a7bc388e5fa3823458d76d67956db71a6f51914af5532117d85"
    sha256 cellar: :any_skip_relocation, big_sur:        "f83cc14109f1ca183425eb0146902cf203fad13d0470718ec599d57b0a93c811"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d468532c89be953fe3ee0e52f64a4fd0b72d09dbf0aca5cb8b717432d216e272"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,NaN
      second header,NULL,,,,,,,,,,0,NaN
    EOS
  end
end
