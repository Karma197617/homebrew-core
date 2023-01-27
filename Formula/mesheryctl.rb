class Mesheryctl < Formula
  desc "Command-line utility for Meshery, the cloud native management plane"
  homepage "https://meshery.io"
  url "https://github.com/meshery/meshery.git",
      tag:      "v0.6.46",
      revision: "886473f79ebd2dc1517d52afa59716796eb1ef8f"
  license "Apache-2.0"
  head "https://github.com/meshery/meshery.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "7aacf25c43b606cc00741e3601e1f5187d31054bc3c0b1ae1f75dcf28acedad1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7aacf25c43b606cc00741e3601e1f5187d31054bc3c0b1ae1f75dcf28acedad1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7aacf25c43b606cc00741e3601e1f5187d31054bc3c0b1ae1f75dcf28acedad1"
    sha256 cellar: :any_skip_relocation, ventura:        "6f88f968418382534cda11e46d7b814684af29f97938147fddcc368c33967f4e"
    sha256 cellar: :any_skip_relocation, monterey:       "6f88f968418382534cda11e46d7b814684af29f97938147fddcc368c33967f4e"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f88f968418382534cda11e46d7b814684af29f97938147fddcc368c33967f4e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a6a062596265136f31bb9b5b8c892e474a4aca7a0a5a8cee4fb7710d32d578d"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.version=v#{version}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.commitsha=#{Utils.git_short_head}
      -X github.com/layer5io/meshery/mesheryctl/internal/cli/root/constants.releasechannel=stable
    ]

    system "go", "build", *std_go_args(ldflags: ldflags), "./mesheryctl/cmd/mesheryctl"

    generate_completions_from_executable(bin/"mesheryctl", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/mesheryctl version 2>&1")
    assert_match "Channel: stable", shell_output("#{bin}/mesheryctl system channel view 2>&1")

    # Test kubernetes error on trying to start meshery
    assert_match "The Kubernetes cluster is not accessible.", shell_output("#{bin}/mesheryctl system start 2>&1", 1)
  end
end
