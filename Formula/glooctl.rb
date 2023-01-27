class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.4",
      revision: "2ef21fe535759f5eed1949fc661c37d4614e6e65"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "00d03805256f3f4d02a486b6512940ece9b2b9350da826396415dc0cf9e4110e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "99be265d733e72c66b2f0e77c4f3d35c92aafe3ef1a92b271f39f6422b117f41"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2e80a7de9449f3085c2d02ec69832a065f4d991044dce8fb88569343cfb0c7ed"
    sha256 cellar: :any_skip_relocation, ventura:        "9196ecb16079eba741134899207359811889c1117399aaed7cc70aefc4191893"
    sha256 cellar: :any_skip_relocation, monterey:       "fc0e185769bb0318aeaa1418a373be6151859daae6b3ca846de929fd40c24936"
    sha256 cellar: :any_skip_relocation, big_sur:        "b47dc3085a24bfb25e802a2ac2e47c91fbba3096fe3b28ce26aa390cffd8fa54"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee666fb5fead44ffb343dfc3b4944438508f20a3c2682a7da3d5a24e794b17d2"
  end

  depends_on "go" => :build

  def install
    system "make", "glooctl", "VERSION=#{version}"
    bin.install "_output/glooctl"

    generate_completions_from_executable(bin/"glooctl", "completion", shells: [:bash, :zsh])
  end

  test do
    run_output = shell_output("#{bin}/glooctl 2>&1")
    assert_match "glooctl is the unified CLI for Gloo.", run_output

    version_output = shell_output("#{bin}/glooctl version 2>&1")
    assert_match "Client: {\"version\":\"#{version}\"}", version_output
    assert_match "Server: version undefined", version_output

    # Should error out as it needs access to a Kubernetes cluster to operate correctly
    status_output = shell_output("#{bin}/glooctl get proxy 2>&1", 1)
    assert_match "failed to create kube client", status_output
  end
end
