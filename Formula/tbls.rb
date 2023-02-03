class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.61.0.tar.gz"
  sha256 "fdd56b014ce94a26753adb16f5ef4e3f8f7f3ce24b0b3febd9b1679318829bf1"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3bc843c1df0b081fe5d70aed7dab067d60524f9f8b434bc8e534fedb2966d3ee"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61208ec3b9a4efdc7688fd3320279a0229b68c9611c43c5d28f365f8f2418d86"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b2bb63e0f9e7c5ad8ebec4f4ef1166abaf60bff81a7b3601c59d64f06911f47d"
    sha256 cellar: :any_skip_relocation, ventura:        "8e156e01d2f5250cba487f84fda1456e35892f5afd02f3a33a82013be7893922"
    sha256 cellar: :any_skip_relocation, monterey:       "ae36826d749696e1f736405fb73b43c940383abd4fad3374a535cd5420c787bd"
    sha256 cellar: :any_skip_relocation, big_sur:        "f7d6b2a9b006549e4f4be32d932026fffbfa9a9ea486cb8d45409c476103d338"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cee408c21cc4d186f48cacabbe2de360c046099551655c68f35f19fdc8dd6ce1"
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
