class Helmify < Formula
  desc "Create Helm chart from Kubernetes yaml"
  homepage "https://github.com/arttor/helmify"
  url "https://github.com/arttor/helmify.git",
      tag:      "v0.3.25",
      revision: "2351ee022fd9ea28084816ec6c5f3880eb456e2b"
  license "MIT"
  head "https://github.com/arttor/helmify.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8d1ab5a7ef1b4bd7f54ca72729e221ab8dbaad373e834a945a1e89fdc9243e2d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0fd5bf59a1b993569dbc86e254cb9006b3518282abd9b137407eaf409bf0304b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "23db428110b7b59a3d88885a1a85a352e6250e197982f01a51e20ab41da1fce8"
    sha256 cellar: :any_skip_relocation, ventura:        "b376730a30da93f4321ca4ded80bd3f54d3ac61a22ab0e8985ecc7d71f319ab5"
    sha256 cellar: :any_skip_relocation, monterey:       "bc6f1296ae861a69e96c45a580ada1021f6a369b0822277bc506dff3ab73bd60"
    sha256 cellar: :any_skip_relocation, big_sur:        "e240e34c88e0ebe712c0efcfffb3c2e619a56b99ccb2cf55b2dc9453616bb9db"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "92d9e1a82ee2556eaf3eba7f5fd347c3d5cffbfec7cadbf74dca8b09eb0dcdc0"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -X main.version=#{version}
      -X main.date=#{time.iso8601}
      -X main.commit=#{Utils.git_head}
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/helmify"
  end

  test do
    test_service = testpath/"service.yml"
    test_service.write <<~EOS
      apiVersion: v1
      kind: Service
      metadata:
        name: brew-test
      spec:
        type: LoadBalancer
    EOS

    expected_values_yaml = <<~EOS
      brewTest:
        ports: []
        type: LoadBalancer
      kubernetesClusterDomain: cluster.local
    EOS

    system "cat #{test_service} | #{bin}/helmify brewtest"
    assert_predicate testpath/"brewtest/Chart.yaml", :exist?
    assert_equal expected_values_yaml, (testpath/"brewtest/values.yaml").read

    assert_match version.to_s, shell_output("#{bin}/helmify --version")
  end
end
