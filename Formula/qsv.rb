class Qsv < Formula
  desc "Ultra-fast CSV data-wrangling toolkit"
  homepage "https://github.com/jqnatividad/qsv"
  url "https://github.com/jqnatividad/qsv/archive/refs/tags/0.90.1.tar.gz"
  sha256 "c144e64fbb0650518e1bd37926ede565d467c5bd5ad4d78f46543eaf3ec83fc6"
  license any_of: ["MIT", "Unlicense"]
  head "https://github.com/jqnatividad/qsv.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d504b2bde76626b38f87acc3877bf5b1114b3bdeec598795cb9bebc6d9d8281"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "09a1def85ad32f02e33b3d5198bfb4bdacd57f8ef3a9b8bd4636f32efbee92a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8677201f325fa4f87f550b3f5647d511e52859403b457a36b4d6efc8540635c9"
    sha256 cellar: :any_skip_relocation, ventura:        "aa5ae37df38f91d9f71fa92a55b1f22e7555c4c4fc44a90d163346a743c80757"
    sha256 cellar: :any_skip_relocation, monterey:       "64179f5bb4c9276a80f07ad49e89dd2b47d0c959f026d5bc08e70e96bb105105"
    sha256 cellar: :any_skip_relocation, big_sur:        "351fdd826f577977810015888a18142a502d4bf31df40f188090a41f0a8eb0e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3abc0a60c50b9457a03921aa9d79feaf0c2e2a1f8b09e140fac312938a205d06"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--features", "apply,full"
  end

  test do
    (testpath/"test.csv").write("first header,second header")
    assert_equal <<~EOS, shell_output("#{bin}/qsv stats test.csv")
      field,type,sum,min,max,range,min_length,max_length,mean,stddev,variance,nullcount,sparsity
      first header,NULL,,,,,,,,,,0,"Failed to convert to decimal ""NaN"""
      second header,NULL,,,,,,,,,,0,"Failed to convert to decimal ""NaN"""
    EOS
  end
end
