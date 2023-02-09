class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.9.5.tar.gz"
  sha256 "8fbff1b97603b14043e60283de1425b02d5e1cf8b340e64c2a1623af035194ee"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "80c61a298f7202db47e20ed1a2b903ec417b418553aa332ac25abb5046cf6d73"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "80c61a298f7202db47e20ed1a2b903ec417b418553aa332ac25abb5046cf6d73"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "80c61a298f7202db47e20ed1a2b903ec417b418553aa332ac25abb5046cf6d73"
    sha256 cellar: :any_skip_relocation, ventura:        "7714721aedfdfb6aeedb0deb47bc56140e28d77bd60093917397370aab3295d1"
    sha256 cellar: :any_skip_relocation, monterey:       "7714721aedfdfb6aeedb0deb47bc56140e28d77bd60093917397370aab3295d1"
    sha256 cellar: :any_skip_relocation, big_sur:        "7714721aedfdfb6aeedb0deb47bc56140e28d77bd60093917397370aab3295d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fcf86ea09154030b8d85ff8cba00d7228f0c3cb38a3627ec997421e09d378c4a"
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
