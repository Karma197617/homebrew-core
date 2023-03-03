class Kubescape < Formula
  desc "Kubernetes testing according to Hardening Guidance by NSA and CISA"
  homepage "https://github.com/kubescape/kubescape"
  url "https://github.com/kubescape/kubescape/archive/refs/tags/v2.2.3.tar.gz"
  sha256 "3b81836f850e02fd0a2b4918ed398e14ab324885486a4d374cb7069a5fbb0502"
  license "Apache-2.0"
  head "https://github.com/kubescape/kubescape.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "69ef7dc344edda8dc0cf2cebdf86169a63675fd0fbe08c9e57707add42839a3a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "264415412177372be6ce2e92673a7469115ff6ce6c29a6efec1eb2a733821695"
    sha256 cellar: :any_skip_relocation, monterey:       "b33d66b12dbd461c7038a53fde23f027046ca30efe51bf66407abe96abf5d934"
    sha256 cellar: :any_skip_relocation, big_sur:        "b38436d3d186c443b5deb669ac7be828296618d0f938dd68dc97340517d58f8b"
    sha256 cellar: :any_skip_relocation, catalina:       "520774f9ca98acc82a4f86d2cc36e83684ad411f41bed5c262296647e1787b5d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8f380152c0c592450d46da3f3731853a452de6fe0a2fe824212465711ff6a9d"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/kubescape/kubescape/v2/core/cautils.BuildNumber=v#{version}
    ]

    system "go", "build", *std_go_args(ldflags: ldflags)

    generate_completions_from_executable(bin/"kubescape", "completion")
  end

  test do
    manifest = "https://raw.githubusercontent.com/GoogleCloudPlatform/microservices-demo/main/release/kubernetes-manifests.yaml"
    assert_match "FAILED RESOURCES", shell_output("#{bin}/kubescape scan framework nsa #{manifest}")

    assert_match version.to_s, shell_output("#{bin}/kubescape version")
  end
end
