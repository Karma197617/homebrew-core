class Flyctl < Formula
  desc "Command-line tools for fly.io services"
  homepage "https://fly.io"
  url "https://github.com/superfly/flyctl.git",
      tag:      "v0.0.464",
      revision: "f9840dd8a1cd25ba3ada1ef5fee2db563d529406"
  license "Apache-2.0"
  head "https://github.com/superfly/flyctl.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d0eb15c2125132b04d92a7e2f8ca5494a4b0fa9df9d16a70216a2f78c9276839"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0eb15c2125132b04d92a7e2f8ca5494a4b0fa9df9d16a70216a2f78c9276839"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d0eb15c2125132b04d92a7e2f8ca5494a4b0fa9df9d16a70216a2f78c9276839"
    sha256 cellar: :any_skip_relocation, ventura:        "8ea1747bf8b655b4ee5e2a1a8603bbe1f97258058083c6dd8fac51e8795c2e08"
    sha256 cellar: :any_skip_relocation, monterey:       "8ea1747bf8b655b4ee5e2a1a8603bbe1f97258058083c6dd8fac51e8795c2e08"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ea1747bf8b655b4ee5e2a1a8603bbe1f97258058083c6dd8fac51e8795c2e08"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "226c62d22d5cb82012a11bd911e33d542cf4c50146d9b2d38d2ede26b7414a7e"
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

    flyctl_status = shell_output("#{bin}/flyctl status 2>&1", 1)
    assert_match "Error No access token available. Please login with 'flyctl auth login'", flyctl_status
  end
end
