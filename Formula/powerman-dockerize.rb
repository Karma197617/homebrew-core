class PowermanDockerize < Formula
  desc "Utility to simplify running applications in docker containers"
  homepage "https://github.com/powerman/dockerize"
  url "https://github.com/powerman/dockerize/archive/refs/tags/v0.18.0.tar.gz"
  sha256 "2b7a6f9913ac7f96e43663b4bec30e3f01d743654c37a02adae4a45944e040c7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "4150c695218245464c65510a8aadb8e750bb7221ee096515c84bb618003c1157"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a084eddc1dfe8a3cc59a4ee2cf3c5fd6246dd3dcd6466bfc92cf09043a0de93d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7f09f71f323a0acf5038b8b299d14eafe938241c8b6e01ba6f89efa969679574"
    sha256 cellar: :any_skip_relocation, ventura:        "7d79134e520146e0b29ecf141b287b30158ef05afb188aba16d4f104e2d2f326"
    sha256 cellar: :any_skip_relocation, monterey:       "a05432095e662527285394f198c46112341f7933fe6846767fff449db4ff6e27"
    sha256 cellar: :any_skip_relocation, big_sur:        "541170e834dc3df6db45fdfc831e010dae4799277180216cf74483065420dc8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9fefb3e840e546f7ff439a330d2a7ca0cd790500c0533096bec4206a7831ecf8"
  end

  depends_on "go" => :build
  conflicts_with "dockerize", because: "powerman-dockerize and dockerize install conflicting executables"

  def install
    system "go", "build", *std_go_args(output: bin/"dockerize", ldflags: "-s -w -X main.ver=#{version}")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/dockerize --version")
    system "#{bin}/dockerize", "-wait", "https://www.google.com/", "-wait-retry-interval=1s", "-timeout", "5s"
  end
end
