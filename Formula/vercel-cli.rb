require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.10.tgz"
  sha256 "d1b375933ef085b5f2256c2a22d3e6ae5a7199a6f511d867565cc3abd0b6538f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "36d062c992d32cb68ad352509f564261ab0844b3e1c35f5c266c395fb6113db7"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cdc75630d84341a9d4f1414dd553426d9ecb7a87c74008e00fdc03cb17cfee49"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "43b48bb5e6bbe2f9639ac9a607a337fc679f30c086b72a06199b972e4de69227"
    sha256 cellar: :any_skip_relocation, ventura:        "39294c8bc3e822e2c3758d6718cd4bfdd3e2afaeb0016d3cc6df48f981238fad"
    sha256 cellar: :any_skip_relocation, monterey:       "b9cf8786b94e2a55e4d92844d2b3c98b6e5b69e44511e5b68d422a8d8d4d4828"
    sha256 cellar: :any_skip_relocation, big_sur:        "a12c8da11caa1ed678cafe104644cb24be40acc6668b767433204c89017ecfe3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "600564682a2d01cd2e042f17dfc6e03d7f4c0523e0ff07f94de522af7508bc5a"
  end

  depends_on "node"

  def install
    inreplace "dist/index.js", "= getUpdateCommand",
                               "= async()=>'brew upgrade vercel-cli'"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]

    # Remove incompatible deasync modules
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    node_modules = libexec/"lib/node_modules/vercel/node_modules"
    node_modules.glob("deasync/bin/*")
                .each { |dir| dir.rmtree if dir.basename.to_s != "#{os}-#{arch}" }

    # Replace universal binaries with native slices
    deuniversalize_machos
  end

  test do
    system "#{bin}/vercel", "init", "jekyll"
    assert_predicate testpath/"jekyll/_config.yml", :exist?, "_config.yml must exist"
    assert_predicate testpath/"jekyll/README.md", :exist?, "README.md must exist"
  end
end
