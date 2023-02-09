require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.11.0.tgz"
  sha256 "45cab8cb2ec055b242e8d0b93df51e8f561da70d13c8236d1f48032250e8ec29"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "717ae0272cd074d86b03548b79c6872af6f04681fc5068dddf4f0893576cd772"
    sha256                               arm64_monterey: "5460b52184f88bad077945174ec9fda9e58f393e0cd9fe31ac88f55b22e7ac3b"
    sha256                               arm64_big_sur:  "5e06f014a4a88ad6bae0c8e184d297aa60c0ed816f60ee9a2d8950dd45166a65"
    sha256                               ventura:        "c7d46e36374fa8ba66f7fb7916e445c7307a419d628578ceff7977a8ba797b1a"
    sha256                               monterey:       "2c2b8c47f72404c9e30020bbf88221bdabf5af1c4f6a02a3e5e39652b30b3dc8"
    sha256                               big_sur:        "1d90ce79496bc5dde0885bea8ebbd8e5721cea19aeec5d73e20b8a02bb9e1299"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "daface36190d75be176fc224702c1808a9d448507f2f9561679ff14ebc3d32f3"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
