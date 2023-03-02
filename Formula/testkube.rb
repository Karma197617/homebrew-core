class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.9.20.tar.gz"
  sha256 "f1ad7ac434c996e15fa63d83ad7e351654952c24863dee1d04ca2e17e43a9fb1"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "95c8aa11915d022e7d6f70af997571fc0794b00bc71666db0a32aa8a43e48962"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "95c8aa11915d022e7d6f70af997571fc0794b00bc71666db0a32aa8a43e48962"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "95c8aa11915d022e7d6f70af997571fc0794b00bc71666db0a32aa8a43e48962"
    sha256 cellar: :any_skip_relocation, ventura:        "81a75056d831244ac8e208fb23bd447b75bab17be08953378ca1a92c3cd467ac"
    sha256 cellar: :any_skip_relocation, monterey:       "81a75056d831244ac8e208fb23bd447b75bab17be08953378ca1a92c3cd467ac"
    sha256 cellar: :any_skip_relocation, big_sur:        "81a75056d831244ac8e208fb23bd447b75bab17be08953378ca1a92c3cd467ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95ae2533ea3bdc0ae0f1fefbbb0f5d5121a4606c85baf38d907fbb1c0f60b907"
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
    assert_match("unknown context type", output)

    output = shell_output("#{bin}/kubectl-testkube help")
    assert_match("Testkube entrypoint for kubectl plugin", output)
  end
end
