class Tbls < Formula
  desc "CI-Friendly tool for document a database"
  homepage "https://github.com/k1LoW/tbls"
  url "https://github.com/k1LoW/tbls/archive/refs/tags/v1.60.0.tar.gz"
  sha256 "1612e26de9f2f82fa71aa00b09c0241944284564eb3642d6b350ca1be7b58add"
  license "MIT"
  head "https://github.com/k1LoW/tbls.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ae5ea46ceaa4bdaa66f357a7aedf1c45d6001da910c6e3da9df4f941bbbb57e7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3b399c88de9f6704be86c7f0465226ee6297bf7ed8b0966537e646e1a898e977"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7a6b8465d4d5388fe3cb2692d3aff3b407262e7ae2ae27fd460a112650315ddf"
    sha256 cellar: :any_skip_relocation, ventura:        "d8a556e0c987946238369d4171c61fe73e344b3f013a1c4c9ee362a598da6e03"
    sha256 cellar: :any_skip_relocation, monterey:       "841ad1335d86e1227ffd0ec279ab19086ed5b57e9555ebab7ff14184975aeced"
    sha256 cellar: :any_skip_relocation, big_sur:        "7150b530ee3986fc9e9af9a2ca436aae754518a788783f41a9c52ae7a67dffa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "72e14c0b54a240062d3c40ac7b5786ded2db1104665a766df7aaa96c4c099870"
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
