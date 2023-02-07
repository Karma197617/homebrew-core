class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.454",
      revision: "8c59e3dc591c6922d1db1cdc17f6e369126dbeba"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9200af3ba594d708cccf357ec911699f28d68cb3d5e081479f7b5652c01ce8da"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9200af3ba594d708cccf357ec911699f28d68cb3d5e081479f7b5652c01ce8da"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9200af3ba594d708cccf357ec911699f28d68cb3d5e081479f7b5652c01ce8da"
    sha256 cellar: :any_skip_relocation, ventura:        "5a59526c521039ed02dd8ad5adcde2ce6b6d909a9fe6318011105138e863fe3a"
    sha256 cellar: :any_skip_relocation, monterey:       "5a59526c521039ed02dd8ad5adcde2ce6b6d909a9fe6318011105138e863fe3a"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a59526c521039ed02dd8ad5adcde2ce6b6d909a9fe6318011105138e863fe3a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ed1e55b8cb22e807c513eee4678ce58bd9a75907cad11d16aec5da3208459b05"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/superfly/flyctl/internal/buildinfo.environment=production
      -X github.com/superfly/flyctl/internal/buildinfo.buildDate=#{time.iso8601}
      -X github.com/superfly/flyctl/internal/buildinfo.version=#{version}
      -X github.com/superfly/flyctl/internal/buildinfo.commit=#{Utils.git_short_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)

    bin.install_symlink "flyctl" => "fly"

    generate_completions_from_executable(bin/"flyctl", "completion")
  end

  test do
    assert_match "flyctl v#{version}", shell_output("#{bin}/flyctl version")

    flyctl_status = shell_output("flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
