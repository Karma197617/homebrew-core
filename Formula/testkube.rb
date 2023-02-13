class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.9.10.tar.gz"
  sha256 "357844cc0b8dea0dcf94b73da5f73c377042cc54a84775b33da65848c690f29b"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "03cbd329c6a292c58c6b6e97d37e73276719ed648374b51fffe86bd875e87a8c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ceb6af1751ba47282b1472bbe9e9dd601a4399bae75431855b0ab72114a56867"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "48cf17e835b54e1e433844ee5949de3e76897e62cfd1251249fc1d2e4ee67323"
    sha256 cellar: :any_skip_relocation, ventura:        "46997e65d11fc9a70f1364edcdcd6e8ab135411c1ce76964add99e481fd569a9"
    sha256 cellar: :any_skip_relocation, monterey:       "c2dc7d4bf05851eee814d40d2c829dcc830677af9c057373a71faf392253f9a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6f98e624d0757d78d5e8a6e767170021146535f095a621c5ee2db182c19fc614"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "af06bb4f040e3a35d1c31cec56b365cc6a465fb4c73ff47a338f77df1c60b906"
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
