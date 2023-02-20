class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.62.1.tar.gz"
  sha256 "2b686beaa50c3be3cb6fa3936b3896696fb9e5da754d503396c275d9bb83961a"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7ddb03424a1aa0bd7cd2026fd939bb14c5c3580ab258f5d6f47217b7d34d661f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "01dc4bfe0fd2fd3cb646eec13f0b3035cbe7e55adf27a03d0aae9cfdc6827fbc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "679e6aa5761fc0593eb0c3fe3130517b1488554287ca76641f9cb72f03517d8f"
    sha256 cellar: :any_skip_relocation, ventura:        "55f111ac84354fc20b283b536291f7e00fd04b65226fe3da5271a4835619cc26"
    sha256 cellar: :any_skip_relocation, monterey:       "2ee5e19ce79cbc44dcc8f32f999c29c35e64616abfb19fba07d8ef8aaa98a02f"
    sha256 cellar: :any_skip_relocation, big_sur:        "7ea017398d8413871d4f7a0a9a9fe5038a54c21d4912a2cc76f0d7b87dbc72a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "792793b42b8a9e2b3186ac93be8a2e17b23ec2abd939810822d3f0022a0e4823"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.iso8601}
      -X github.com/k1LoW/tbls/version.Version=#{version}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"tbls", "completion")
  end

  test do
    assert_match "invalid database scheme", shell_output(bin/"tbls doc", 1)
    assert_match version.to_s, shell_output(bin/"tbls version")
  end
end
