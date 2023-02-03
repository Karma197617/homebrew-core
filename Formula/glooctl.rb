class Glooctl < Formula
  desc "Envoy-Powered API Gateway"
  homepage "https://docs.solo.io/gloo/latest/"
  # NOTE: Please wait until the newest stable release is finished building and
  # no longer marked as "Pre-release" before creating a PR for a new version.
  url "https://github.com/solo-io/gloo.git",
      tag:      "v1.13.5",
      revision: "3ce659a6e7e76f2ce38d3a8c60bafc21924da9e5"
  license "Apache-2.0"
  head "https://github.com/solo-io/gloo.git", branch: "master"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fbf0fb5cb3379421a41da4749e5fa7c5cc22cdeae80e1947bd9460e55110ce10"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14add2c603bbcc080952ac4cd46ac95dd8a02e24f12e9d017a9c358ceb6bb9a7"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7e684aa15f1c6d663524e6dd87cf65af1d7c3e2e48ca9690384f64863e7e0a55"
    sha256 cellar: :any_skip_relocation, ventura:        "db664cd3bdfdf181fba2ecf5eaff9aa02545713061ddba65f3aedf376b683946"
    sha256 cellar: :any_skip_relocation, monterey:       "23250f70bdbe9a1c18535ad93485b811181386240a1e86c5c7a722e22f2c02cd"
    sha256 cellar: :any_skip_relocation, big_sur:        "fb6238fc3c6411b67364af7dd908ac93de40f0a66a77f1449390ccdde8437be7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "483c03829b4ecca0415925d73a2b2707aa69a138827518c1e4e13ccc39b8b8e0"
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
