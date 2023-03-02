require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.0.tgz"
  sha256 "f087438ff918d845b7c9a5cd4b19b45d055a65dce57121eb64bc15d80ab4567d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b10bec9dd955fa092e7e76dfa0629e2988ef80d7ab27496c7f94b3459b90c35f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b10bec9dd955fa092e7e76dfa0629e2988ef80d7ab27496c7f94b3459b90c35f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b10bec9dd955fa092e7e76dfa0629e2988ef80d7ab27496c7f94b3459b90c35f"
    sha256 cellar: :any_skip_relocation, ventura:        "fac1738178236edbc05aa03538dd6b8740122b54457ac165515e6ee7b75aeacf"
    sha256 cellar: :any_skip_relocation, monterey:       "fac1738178236edbc05aa03538dd6b8740122b54457ac165515e6ee7b75aeacf"
    sha256 cellar: :any_skip_relocation, big_sur:        "fac1738178236edbc05aa03538dd6b8740122b54457ac165515e6ee7b75aeacf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b10bec9dd955fa092e7e76dfa0629e2988ef80d7ab27496c7f94b3459b90c35f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
