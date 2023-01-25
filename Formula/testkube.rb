class Testkube < Formula
  desc "Kubernetes-native framework for test definition and execution"
  homepage "https://testkube.io"
  # testkube should only be updated every 5 releases on multiples of 5
  url "https://github.com/kubeshop/testkube/archive/v1.8.35.tar.gz"
  sha256 "939f4c97fb8baf306b90ab2175b9eaee455ecd9ac2c5d55e2441111f3fbe793e"
  license "MIT"
  head "https://github.com/kubeshop/testkube.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "535d36b5419d46d29f34f4d988a4ced8334a2f57d8ca9cf1353c085b3c79d60e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "535d36b5419d46d29f34f4d988a4ced8334a2f57d8ca9cf1353c085b3c79d60e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "535d36b5419d46d29f34f4d988a4ced8334a2f57d8ca9cf1353c085b3c79d60e"
    sha256 cellar: :any_skip_relocation, ventura:        "d8297b2c59884cb11a4d74306534b31c96a3dbd26d8121bf5c51683c3fee7b5c"
    sha256 cellar: :any_skip_relocation, monterey:       "d8297b2c59884cb11a4d74306534b31c96a3dbd26d8121bf5c51683c3fee7b5c"
    sha256 cellar: :any_skip_relocation, big_sur:        "d8297b2c59884cb11a4d74306534b31c96a3dbd26d8121bf5c51683c3fee7b5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9962c973e9112c476258190781cc10d18d540ba7c530a6ef9c5c7b306e4c737e"
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
