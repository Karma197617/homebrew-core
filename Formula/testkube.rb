class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.8.30.tar.gz"
  sha256 "5dd432bc2062cbe12c6b8987bcbcf5ad227d45846a26f3519bc4da30d711b0cd"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c251e9bcb9a6b80a2ac0ac834bdaf8ad24f7e345b1c96861145f12720f0802c5"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c251e9bcb9a6b80a2ac0ac834bdaf8ad24f7e345b1c96861145f12720f0802c5"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c251e9bcb9a6b80a2ac0ac834bdaf8ad24f7e345b1c96861145f12720f0802c5"
    sha256 cellar: :any_skip_relocation, ventura:        "d9e88d4b61a3f05648a32387375af8659c365723766cd6b061a3ddb9ff97c7c0"
    sha256 cellar: :any_skip_relocation, monterey:       "d9e88d4b61a3f05648a32387375af8659c365723766cd6b061a3ddb9ff97c7c0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d9e88d4b61a3f05648a32387375af8659c365723766cd6b061a3ddb9ff97c7c0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f85cf61197a7a4f35dc9c7b7179786d101a519a03eb6c347a0b21e031ea1a6d"
  end

  depends_on "go" => :build
  depends_on "helm"
  depends_on "kubernetes-cli"

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X main.version=#{version}
      -X main.builtBy=#{tap.user}
    ]

    system "go", "build", *std_go_args(output: bin/"kubectl-testkube", ldflags: ldflags),
      "cmd/kubectl-testkube/main.go"

    bin.install_symlink "kubectl-testkube" => "testkube"

    generate_completions_from_executable(bin/"kubectl-testkube", "completion")
  end

  test do
    output = shell_output("#{bin}/kubectl-testkube get tests 2>&1", 1)
    assert_match("error: invalid configuration: no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
