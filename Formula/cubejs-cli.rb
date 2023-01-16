require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.45.tgz"
  sha256 "349e3efefeb5878074452cb3ef6e4af664e7e6d2805580649b29898212c3131d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5dad359dc5940d09db58bdb447890374dd1ec3bdbe3b212e8bc17f88f27ac8c8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5dad359dc5940d09db58bdb447890374dd1ec3bdbe3b212e8bc17f88f27ac8c8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5dad359dc5940d09db58bdb447890374dd1ec3bdbe3b212e8bc17f88f27ac8c8"
    sha256 cellar: :any_skip_relocation, ventura:        "be63bc273f9b6b861a69566bc41989c3a3550dd461b5864147d25dad6e95a7cf"
    sha256 cellar: :any_skip_relocation, monterey:       "be63bc273f9b6b861a69566bc41989c3a3550dd461b5864147d25dad6e95a7cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "be63bc273f9b6b861a69566bc41989c3a3550dd461b5864147d25dad6e95a7cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5dad359dc5940d09db58bdb447890374dd1ec3bdbe3b212e8bc17f88f27ac8c8"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
