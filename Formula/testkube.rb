class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.9.0.tar.gz"
  sha256 "08a01c5d53d2fb03f926ae72f2c8e97d76dab6a3aeba2097e8f817dc06b5f06e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "33e9df565de0cbb33dbd81054dd77fd0c37ce0b710fbff9e14f464e928c724fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "33e9df565de0cbb33dbd81054dd77fd0c37ce0b710fbff9e14f464e928c724fa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "33e9df565de0cbb33dbd81054dd77fd0c37ce0b710fbff9e14f464e928c724fa"
    sha256 cellar: :any_skip_relocation, ventura:        "4da6cfd7a577c17f0746580efeb57e5b4701fc04b4e7ff49fb4057c5696f214e"
    sha256 cellar: :any_skip_relocation, monterey:       "4da6cfd7a577c17f0746580efeb57e5b4701fc04b4e7ff49fb4057c5696f214e"
    sha256 cellar: :any_skip_relocation, big_sur:        "4da6cfd7a577c17f0746580efeb57e5b4701fc04b4e7ff49fb4057c5696f214e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3018abbb87cd87e28dac536e3db9ff07eb5e400ca7b45c0e0eb207c5d51cb7b9"
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
