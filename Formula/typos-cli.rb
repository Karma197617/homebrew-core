class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.14.tar.gz"
  sha256 "5c16767a96d21d83aba59cf0d065765bbe7dc435ec39219264ad24447a786062"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "35f4ed5a9795db57ba792044d6663edce76e2487b2449b077f43cd7e8432cb3c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f1e261a2bbc1762f694b9058cd72685e69c57246aa2c1d7e574dafa5847e6d53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "57c22b46153e5f89259c1acf5c5427fe42233c54cd89d6749215ede14509d844"
    sha256 cellar: :any_skip_relocation, ventura:        "899a9304d64d27a64d000396788b4d761bdff3a5ee5439664fe3a89e31506fbb"
    sha256 cellar: :any_skip_relocation, monterey:       "375a329509e689986b4eea2613593c4b8d0090d4cdb99aba777de25613091a73"
    sha256 cellar: :any_skip_relocation, big_sur:        "507fbb04f3919e7e7e725ff6138c62dd028f4aee28547ec1389113480a75bda0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a4c83e4bd462e14adad8f248e96304725109efcf87e47bd3651e033930dc58ac"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match "error: `teh` should be `the`", pipe_output("#{bin}/typos -", "teh", 2)
    assert_empty pipe_output("#{bin}/typos -", "the")
  end
end
