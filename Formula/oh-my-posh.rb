class OhMyPosh < Formula
  desc "Prompt theme engine for any shell"
  homepage "https://ohmyposh.dev"
  url "https://github.com/JanDeDobbeleer/oh-my-posh/archive/v14.2.5.tar.gz"
  sha256 "0d493852380ce2885c7e10310fbe3f15029e9a4e288e44b40bf1bf1ee3e28d29"
  license "MIT"
  head "https://github.com/JanDeDobbeleer/oh-my-posh.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d97d3605b5f5c878a951e4c78e254f3527809bd0da7fb0e6a8cd184173492f81"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9e4e7e1d6c93751667d427394cffd4ed08e2e442ad636f9b91a888ae4b9a8481"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1c313971ce5ab6015718f313f3089ab186de80ecf2e8149a1b6c91084cd0f358"
    sha256 cellar: :any_skip_relocation, ventura:        "ef58b70d54c429d14b44a3b35aab629f8ba49257065d7761b365354f842e6519"
    sha256 cellar: :any_skip_relocation, monterey:       "c14d00007dbde9f67099f4d227f4c20d362c3dc41db4867c1a6e290a6b008090"
    sha256 cellar: :any_skip_relocation, big_sur:        "79e024a2fa448d09107ccace0c1f1bea1a92a309da4234597cbf3465ec565015"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d83365b780e65932bdc771ce311ef1528ddf91c5e040acbcd91ee4e27e1e6bad"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X main.Version=#{version}
    ]
    cd "src" do
      system "go", "build", *std_go_args(ldflags: ldflags)
    end

    prefix.install "themes"
    pkgshare.install_symlink prefix/"themes"
  end

  test do
    assert_match "oh-my-posh", shell_output("#{bin}/oh-my-posh --init --shell bash")
  end
end
