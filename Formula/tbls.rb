class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.59.0.tar.gz"
  sha256 "50470307ab73c2af9a2760dd56a4775a3a99fb8a9b0ba2c451e5915c1a7e1513"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4d535615079bb6710185aa8ee7da70bb73d9cb21c3ff5796a17105dcbabafee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "051477c59a3f92d55c72f7cdbd2b63af3394b68a720a1e96132647abf8adbf0f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "00a903ebef3b8acd4e4c9c56ac253cb18115fdd77f93bc4578c74f45ca4229d8"
    sha256 cellar: :any_skip_relocation, ventura:        "f03d44a1c284df8643ea3147de05d3985c851c57fe96eb2cd069461bec2af256"
    sha256 cellar: :any_skip_relocation, monterey:       "8939d00e7a6f4cba7b6e399fad4895f618fa59d9c2f068a24b5bf0d05ae6d2cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "efa4a335168977fe71bbed2658bdd22273fa3a37dbe3cd866977f6d898bae889"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7e4a3e042c66029e8b336bc215408596f0ad62de4fd3f271ba34db6e3dce294a"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/k1LoW/tbls.version=#{version}
      -X github.com/k1LoW/tbls.date=#{time.rfc3339}
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
