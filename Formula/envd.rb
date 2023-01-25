class Envd < Formula
  desc "Reproducible development environment for AI/ML"
  homepage "https://envd.tensorchord.ai"
  url "https://github.com/tensorchord/envd/archive/v0.3.10.tar.gz"
  sha256 "40b97a99511df8a1978c0b19136cfdd24f474bc49f82668d66cb5f74faed277b"
  license "Apache-2.0"
  head "https://github.com/tensorchord/envd.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "30b446467234ed7f6d0b2c843d72400717dcda575f2fd0675bc9e195664e9709"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "30b446467234ed7f6d0b2c843d72400717dcda575f2fd0675bc9e195664e9709"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30b446467234ed7f6d0b2c843d72400717dcda575f2fd0675bc9e195664e9709"
    sha256 cellar: :any_skip_relocation, ventura:        "744b28e77a2da74cf01bafc9c93e00fc437f6cfadcac9e990bd00235938920b1"
    sha256 cellar: :any_skip_relocation, monterey:       "744b28e77a2da74cf01bafc9c93e00fc437f6cfadcac9e990bd00235938920b1"
    sha256 cellar: :any_skip_relocation, big_sur:        "744b28e77a2da74cf01bafc9c93e00fc437f6cfadcac9e990bd00235938920b1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "98ae2f6a903b1adf97be6f60d387e351ea8687625d568992d75c674f8da3e91a"
  end

  depends_on "go" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    ldflags = %W[
      -s -w
      -X github.com/tensorchord/envd/pkg/version.buildDate=#{time.iso8601}
      -X github.com/tensorchord/envd/pkg/version.version=#{version}
      -X github.com/tensorchord/envd/pkg/version.gitTag=v#{version}
      -X github.com/tensorchord/envd/pkg/version.gitCommit=#{version}-#{tap.user}
      -X github.com/tensorchord/envd/pkg/version.gitTreeState=clean
    ]
    system "go", "build", *std_go_args(ldflags: ldflags), "./cmd/envd"
    generate_completions_from_executable(bin/"envd", "completion", "--no-install",
                                         shell_parameter_format: "--shell=",
                                         shells:                 [:bash, :zsh])
  end

  test do
    output = shell_output("#{bin}/envd version --short")
    assert_equal "envd: v#{version}", output.strip

    expected = if OS.mac?
      "error: Cannot connect to the Docker daemon"
    else
      "error: permission denied"
    end

    stderr = shell_output("#{bin}/envd env list 2>&1", 1)
    assert_match expected, stderr
  end
end
