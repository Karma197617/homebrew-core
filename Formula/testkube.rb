class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.9.25.tar.gz"
  sha256 "16f7337ad781efa3abcf2e0278be655f6236a039426f4ddf01507a4198fdf31d"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93bece5ae4981c53385cc4f3f1d806056be8cf629b89936644753d8f2f943c6b"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93bece5ae4981c53385cc4f3f1d806056be8cf629b89936644753d8f2f943c6b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "93bece5ae4981c53385cc4f3f1d806056be8cf629b89936644753d8f2f943c6b"
    sha256 cellar: :any_skip_relocation, ventura:        "0a4ef3c70d4168e612457a7bc9e686791de99691907b6bfd9d0726130da0b087"
    sha256 cellar: :any_skip_relocation, monterey:       "99c447877f8bad40667f6e9c3753a9e7e80bf50193ad9497967d47cd8da4deec"
    sha256 cellar: :any_skip_relocation, big_sur:        "0a4ef3c70d4168e612457a7bc9e686791de99691907b6bfd9d0726130da0b087"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4615e9fce69e5e25f5f88fb6b67fa82c39a9a9927dd626b9c105d7b0e43c79d"
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
    assert_match("no configuration has been provided", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
