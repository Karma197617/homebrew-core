class CiliumCli < Formula
  desc "CLI to install, manage & troubleshoot Kubernetes clusters running Cilium"
  homepage "https://cilium.io"
  url "https://github.com/cilium/cilium-cli/archive/refs/tags/v0.13.0.tar.gz"
  sha256 "f02b19f07fc8a87d15aff7a5293fbd0e57db95adda68d260ba08975a1844e89b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "38c86d58d08c95f2f6896a2f2f86cbea1588edc28fb4b653d7653188db8580db"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59e5812798e8570f1701a6282ca4de7cb8454ec99e14ed347e026dd464c462cf"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9b2c79c4102e3069370742bc0828a397aea1697b84bcfde478d8144dec1345c6"
    sha256 cellar: :any_skip_relocation, ventura:        "38bee46adebdf62fe73f8d99a8af555370c099b30cbf5051a84d6a1da04a6ddf"
    sha256 cellar: :any_skip_relocation, monterey:       "5338421c3b84eb9de378f8af9345ba5fad60c120b5a2495adaec0a29522309de"
    sha256 cellar: :any_skip_relocation, big_sur:        "0e6f422d7c9e57220a87f7d5fd15d1382a7dc3b14dd18817ba3dec11562cd999"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8237d61b397c34b388903fd1b914b041cd4362d8b0fb9ff6fb47f640712aeb70"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X github.com/cilium/cilium-cli/internal/cli/cmd.Version=#{version}"
    system "go", "build", *std_go_args(output: bin/"cilium", ldflags: ldflags), "./cmd/cilium"

    generate_completions_from_executable(bin/"cilium", "completion", base_name: "cilium")
  end

  test do
    assert_match('Cluster name "" is not valid', shell_output("#{bin}/cilium install 2>&1", 1))
    assert_match("Error: Unable to enable Hubble", shell_output("#{bin}/cilium hubble enable 2>&1", 1))
  end
end
