require "language/node"

class VercelCli < Formula
  desc "Command-line interface for Vercel"
  homepage "https://vercel.com/home"
  url "https://registry.npmjs.org/vercel/-/vercel-28.16.15.tgz"
  sha256 "f0287570511d9f5c59504eb45b14b4893b89502a4552c7fadf7ae2362d72d1e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6a24447d70f11885c614a776da658ca4cde0552c8b72d60b14b1782fa17c0f3f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b4e4262ef2b442d5b8f9af9a633aefb2245b5c198561bb356c3190bc8c658aae"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "30e2462907d4914b5cac94a34cffad9ba095bfa1d2822b8bdf57f06b54f53683"
    sha256 cellar: :any_skip_relocation, ventura:        "08edfb2480dab46b6407b24d270bdf24c45a9dcc3f2ae930194a45f4b9581c92"
    sha256 cellar: :any_skip_relocation, monterey:       "a9cb360f4a82f1b312dd7405ba554225d2807f26daf13ccc83bc1e8588cc4281"
    sha256 cellar: :any_skip_relocation, big_sur:        "aa19447e6a4e018a91ac813cfaea77baa2783f17e0301f2896219be7506f8f1e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8564620e2a5f152d27ba2b02b0fd52c2f5e13de52e64575f96ec9e85b1b2fe34"
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
