class Cli53 < Formula
  desc "Command-line tool for Amazon Route 53"
  homepage "https://github.com/barnybug/cli53"
  url "https://github.com/barnybug/cli53/archive/0.8.22.tar.gz"
  sha256 "5acf576662cf8cb01ecbe027dfc3531e19bd03c1cd22425125e2a0a986273a7a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "55a348856802e3ae54789282636decbbddea7992f79ae7f05c73df2958288764"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55a348856802e3ae54789282636decbbddea7992f79ae7f05c73df2958288764"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "55a348856802e3ae54789282636decbbddea7992f79ae7f05c73df2958288764"
    sha256 cellar: :any_skip_relocation, ventura:        "7fe0b47ada9f15bfb24e4f2bc9a3642002d945e6742f0424e54c0813a87ef485"
    sha256 cellar: :any_skip_relocation, monterey:       "7fe0b47ada9f15bfb24e4f2bc9a3642002d945e6742f0424e54c0813a87ef485"
    sha256 cellar: :any_skip_relocation, big_sur:        "7fe0b47ada9f15bfb24e4f2bc9a3642002d945e6742f0424e54c0813a87ef485"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4bd5b3432c792e8650a1a1d2687e9a8b55f22d13b625b42eca0ba8844353e83e"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/cli53"
  end

  test do
    assert_match "list domains", shell_output("#{bin}/cli53 help list")
  end
end
