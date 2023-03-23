class Cadence < Formula
  desc "Resource-oriented smart contract programming language"
  homepage "https://github.com/onflow/cadence"
  url "https://github.com/onflow/cadence/archive/v0.37.0.tar.gz"
  sha256 "73d8d9f1bcd102c9726abf7fcbb892d951aaf556b7e005e900542f3d37b8ad49"
  license "Apache-2.0"
  head "https://github.com/onflow/cadence.git", branch: "master"

  # Upstream uses GitHub releases to indicate that a version is released
  # (there's also sometimes a notable gap between when a version is tagged and
  # and the release is created), so the `GithubLatest` strategy is necessary.
  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e4fd3483c645a4567e32c0199e5c9cc08800490acdea29e423f111518a9e0f08"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e8f92b5232c1e1e2d353e70eb78ce3641373ab03637df75ed2e41915126b8eff"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f97de3f5400d5fbbb7a21ddb86bed581bfaceecb2721ae63157f116c5ecdc92"
    sha256 cellar: :any_skip_relocation, ventura:        "ffbe29d8fe61aae29f354d7ff8b136bc9548aefe69d5b86cd8bab9978240debd"
    sha256 cellar: :any_skip_relocation, monterey:       "ed71ad9a9edf0bae936ce67d70c33c4630f4efb7129a99d6f8dde6850284ad8c"
    sha256 cellar: :any_skip_relocation, big_sur:        "f5d5b279b781869d2f632aad864d5b608ef6d37f85aaaf83b7eec5683556e713"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d94b4befe85bf8353e3b4d86d963940f04dd59dc5e5dc945dcdd12100abdbd42"
  end

  depends_on "go" => :build

  conflicts_with "cadence-workflow", because: "both install a `cadence` executable"

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./runtime/cmd/main"
  end

  test do
    (testpath/"hello.cdc").write <<~EOS
      pub fun main(): Int {
        return 0
      }
    EOS
    system "#{bin}/cadence", "hello.cdc"
  end
end
