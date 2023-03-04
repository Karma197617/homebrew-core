class Railway < Formula
  desc "Develop and deploy code with zero configuration"
  homepage "https://railway.app/"
  url "https://github.com/railwayapp/cli/archive/refs/tags/v3.0.5.tar.gz"
  sha256 "c6ce2cedef7ffc8826273a5a68002f240118c103cfe9bd15dd3a0ab5a2fdecd5"
  license "MIT"
  head "https://github.com/railwayapp/cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23ba49b513e76c2157b9d4e047dc84eac7d62454ecd3ca74cdfd008820c80695"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53e0e52126d10351e197518991565a3ac2edae513adaf4922d9efdd093744601"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "225eada7091e989a56ea94919f7e421b5dd8d3133fabdf20574c2bd4117d7379"
    sha256 cellar: :any_skip_relocation, ventura:        "9d717ee2c9025050ffe86d8ea73a41191f1baeaffcb0ad09c197e6bdfce42f44"
    sha256 cellar: :any_skip_relocation, monterey:       "64a955aeb8ddea1041bb5b7106e02999ff8da6cf936ad1ce2e9db100f3530a1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "ae1e85c3911ef1134b37a93b3ade506be129ed9a0f6bc772ae057523eec0a693"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b45ab6303ae47c9289003402ca5c4340eb7c6d7b7209257ea21445e595d698c0"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args

    # Install shell completions
    generate_completions_from_executable(bin/"railway", "completion")
  end

  test do
    output = shell_output("#{bin}/railway init 2>&1", 1)
    assert_match "Error: Unauthorized. Please login with `railway login`", output

    assert_equal "railwayapp #{version}", shell_output("#{bin}/railway --version").chomp
  end
end
