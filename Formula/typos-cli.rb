class TyposCli < Formula
  desc "Source code spell checker"
  homepage "https://github.com/crate-ci/typos"
  url "https://github.com/crate-ci/typos/archive/refs/tags/v1.13.6.tar.gz"
  sha256 "94e3ef34a9f6c2d102958c6ad934fe98ffc45a1ec51be75e0b639059014474cf"
  license any_of: ["Apache-2.0", "MIT"]

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d14d059b79f6dfe4305fc5cb846d73c68f38295037059125bf5b39e984b9ed9d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "399bc4b0c9891482d6f6010febb26ae9d493e5d091c92739bfb31e990868a88e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1e65e7974c2d2c28f7b88f1a11f4d6f68571a19823d0348e779ea005fbb9d566"
    sha256 cellar: :any_skip_relocation, ventura:        "6cdeb0fb630941deb5b18de573d510e9dd0d52405ac8dc08fcaf61e81a081e92"
    sha256 cellar: :any_skip_relocation, monterey:       "ac4338fc43107dcc0f1e990eda821a2e1b03a6743c5d3bff4e0b6b3cc75dd691"
    sha256 cellar: :any_skip_relocation, big_sur:        "4aad23866b03bc2396c4eeb43092c209016d27b54dd301158b79de0831e7b9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4bde546da9464d78a681a03d582d9d82aa9dd8e48d38bdabb81b2a2f772855c"
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
