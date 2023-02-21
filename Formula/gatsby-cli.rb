require "language/node"

class GatsbyCli < Formula
  desc "Gatsby command-line interface"
  homepage "https://www.gatsbyjs.org/docs/gatsby-cli/"
  # gatsby-cli should only be updated every 10 releases on multiples of 10
  url "https://registry.npmjs.org/gatsby-cli/-/gatsby-cli-5.7.0.tgz"
  sha256 "9250b020c004af542c1f64a5af845f77f899fba5a6a51ce2bb6f5cc90078e0c4"
  license "MIT"

  bottle do
    sha256                               arm64_ventura:  "2c300334e45a81a92e5e63705605d26967e0659de7bcefdc3a008cf570b4617d"
    sha256                               arm64_monterey: "e707d8cc1b1d9425289ed2a079e5822eb192e2cb142dd5178b06e3739e7a89b9"
    sha256                               arm64_big_sur:  "078b7375a845c941c0d889e946734b449efa63e391bf4547c917558431c83440"
    sha256                               ventura:        "3006c97645137299e067e58f01d783565a0f6ba09c25beaa1ced7a4f71a041d8"
    sha256                               monterey:       "705cc80c4af262aa79ebf52385123b5eb73888a056677c671d1dc34cc2721b27"
    sha256                               big_sur:        "5878f0968ba9c3930c8abe8eff1b27428ceb80d6d0f300093a3339aef422cae5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6e602d81b7b22107a15339e9b75da8c3299bf249421b6a1dfa1f64148dd92697"
  end

  depends_on "node"

  on_linux do
    depends_on "xsel"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir[libexec/"bin/*"]

    # Remove incompatible pre-built binaries
    node_modules = libexec/"lib/node_modules/#{name}/node_modules"
    arch = Hardware::CPU.intel? ? "x64" : Hardware::CPU.arch.to_s
    if OS.linux?
      %w[@lmdb/lmdb @msgpackr-extract/msgpackr-extract].each do |mod|
        node_modules.glob("#{mod}-linux-#{arch}/*.musl.node")
                    .map(&:unlink)
                    .empty? && raise("Unable to find #{mod} musl library to delete.")
      end
    end

    clipboardy_fallbacks_dir = node_modules/"clipboardy/fallbacks"
    clipboardy_fallbacks_dir.rmtree # remove pre-built binaries
    if OS.linux?
      linux_dir = clipboardy_fallbacks_dir/"linux"
      linux_dir.mkpath
      # Replace the vendored pre-built xsel with one we build ourselves
      ln_sf (Formula["xsel"].opt_bin/"xsel").relative_path_from(linux_dir), linux_dir
    end
  end

  test do
    system bin/"gatsby", "new", "hello-world", "https://github.com/gatsbyjs/gatsby-starter-hello-world"
    assert_predicate testpath/"hello-world/package.json", :exist?, "package.json was not cloned"
  end
end
