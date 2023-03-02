class Hugo < Formula
  desc "Configurable static site generator"
  homepage "https://gohugo.io/"
  url "https://github.com/gohugoio/hugo/archive/v0.111.1.tar.gz"
  sha256 "a71d4e1f49ca7156d3811c0b10957816b75ff2e01b35ef326e7af94dfa554ec0"
  license "Apache-2.0"
  head "https://github.com/gohugoio/hugo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f5e9412427b5ad37e9ba77945333e0b9dd93409baae81abcd1a14058f94c453d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a413cecf8d89a67a59e68bb4e6aaea2b709a15d98956cc538ded7af5d0ff1295"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "35ecf57e6814e9aa60189abb90736ee1fbd6585035cf1719a85460c010e870f6"
    sha256 cellar: :any_skip_relocation, ventura:        "3b613e898618067b8e1b35fdc2bffa45a5fb6c28e80af1b5fc5a7b32b423cd7b"
    sha256 cellar: :any_skip_relocation, monterey:       "354c2d61405ad47a9bcc5551dd2d4e18ceaeb3095a8d8ac4f7175b929562ae1b"
    sha256 cellar: :any_skip_relocation, big_sur:        "05f82e7caa38fd76a506b8644fe6e76b4de07b04eeb566eb198fd035c312b8c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d664b312b67145b970a2af966a6e0acb4b07d3a7ac3e64df1514a944b52fd25b"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "-tags", "extended"

    generate_completions_from_executable(bin/"hugo", "completion")

    # Build man pages; target dir man/ is hardcoded :(
    (Pathname.pwd/"man").mkpath
    system bin/"hugo", "gen", "man"
    man1.install Dir["man/*.1"]
  end

  test do
    site = testpath/"hops-yeast-malt-water"
    system "#{bin}/hugo", "new", "site", site
    assert_predicate testpath/"#{site}/config.toml", :exist?
  end
end
