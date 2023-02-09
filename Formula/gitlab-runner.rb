class GitlabRunner < Formula
  desc "Official GitLab CI runner"
  homepage "https://gitlab.com/gitlab-org/gitlab-runner"
  url "https://gitlab.com/gitlab-org/gitlab-runner.git",
      tag:      "v15.8.2",
      revision: "4d1ca121d038f144403474b90f0ad64182346f12"
  license "MIT"
  head "https://gitlab.com/gitlab-org/gitlab-runner.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8cda8916a42f9c02c5f0f410f0c16457f99badb5f774f397435dd23ec729babd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4d4bd6f4464accc7660fdba9cbc372b3bdcc9f0547ae6f3bda3aba819e5a898f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "03f09e0c1f97e63e1a5514575a9287aee74647cb143bb9c4d24b9497881b69ca"
    sha256 cellar: :any_skip_relocation, ventura:        "567e5c2f598d22ccf73a66e482ae5f06ea704090b1c9cf596ad2fcda25ee4197"
    sha256 cellar: :any_skip_relocation, monterey:       "dafa0af3085bdc158869bdf5856b9bff9dae488b23cda4a1a817ee37c797ead8"
    sha256 cellar: :any_skip_relocation, big_sur:        "25c6f648b524251c7ade4b5383a67566e8fbf66be976472c7d12ff93cd551026"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0ba59d3c27b1a5319b9df45cf0f4edec9081da84ed18ecf16542018a4e058d1f"
  end

  depends_on "go" => :build

  def install
    proj = "gitlab.com/gitlab-org/gitlab-runner"
    ldflags = %W[
      -X #{proj}/common.NAME=gitlab-runner
      -X #{proj}/common.VERSION=#{version}
      -X #{proj}/common.REVISION=#{Utils.git_short_head(length: 8)}
      -X #{proj}/common.BRANCH=#{version.major}-#{version.minor}-stable
      -X #{proj}/common.BUILT=#{time.strftime("%Y-%m-%dT%H:%M:%S%:z")}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags)
  end

  service do
    run [opt_bin/"gitlab-runner", "run", "--syslog"]
    environment_variables PATH: std_service_path_env
    working_dir Dir.home
    keep_alive true
    macos_legacy_timers true
    process_type :interactive
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/gitlab-runner --version")
  end
end
